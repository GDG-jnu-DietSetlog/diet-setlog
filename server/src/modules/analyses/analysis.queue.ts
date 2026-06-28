import { Queue, Worker, type Job } from 'bullmq';
import { redisConnection } from '../../lib/redis.js';
import { prisma } from '../../prisma.js';
import { getObjectBuffer } from '../../lib/storage.js';
import { analyzeFoodImage } from '../../lib/gemini.js';
import { normalizeAnalysis } from '../../lib/normalize.js';

const QUEUE = 'food-analysis';
const MODEL_TIMEOUT_MS = 15000; // spec-lock §9

export const analysisQueue = new Queue(QUEUE, { connection: redisConnection });

export async function enqueueAnalysis(analysisId: string): Promise<void> {
  await analysisQueue.add(
    'analyze',
    { analysisId },
    {
      attempts: 2,
      backoff: { type: 'exponential', delay: 1000 },
      removeOnComplete: 100,
      removeOnFail: 100,
    },
  );
}

function mimeFromKey(key: string): string {
  if (key.endsWith('.png')) return 'image/png';
  if (key.endsWith('.webp')) return 'image/webp';
  return 'image/jpeg';
}

function withTimeout<T>(p: Promise<T>, ms: number): Promise<T> {
  return Promise.race([
    p,
    new Promise<T>((_, reject) => setTimeout(() => reject(new Error('MODEL_TIMEOUT')), ms)),
  ]);
}

async function processJob(job: Job<{ analysisId: string }>): Promise<void> {
  const { analysisId } = job.data;
  const analysis = await prisma.foodAnalysis.findUnique({ where: { id: analysisId } });
  if (!analysis) return;

  try {
    const buffer = await getObjectBuffer(analysis.imageKey);
    const raw = await withTimeout(
      analyzeFoodImage(buffer, mimeFromKey(analysis.imageKey)),
      MODEL_TIMEOUT_MS,
    );
    const outcome = normalizeAnalysis(raw);

    if (outcome.status === 'completed') {
      await prisma.foodAnalysis.update({
        where: { id: analysisId },
        data: {
          status: 'completed',
          result: outcome.result as object,
          geminiRaw: raw as object,
          needsReview: outcome.needsReview,
        },
      });
    } else {
      await prisma.foodAnalysis.update({
        where: { id: analysisId },
        data: {
          status: 'failed',
          geminiRaw: raw as object,
          errorCode: outcome.errorCode,
          errorMsg: outcome.message,
        },
      });
    }
  } catch (e) {
    const isTimeout = e instanceof Error && e.message === 'MODEL_TIMEOUT';
    await prisma.foodAnalysis.update({
      where: { id: analysisId },
      data: {
        status: 'failed',
        errorCode: isTimeout ? 'MODEL_TIMEOUT' : 'MODEL_ERROR',
        errorMsg: e instanceof Error ? e.message : 'unknown',
      },
    });
  }
}

let worker: Worker | null = null;

// 워커 기동(서버 부팅 시). 비동기 큐로 요청 흐름과 분리(spec-lock §5.1).
export function startAnalysisWorker(): Worker {
  if (!worker) {
    worker = new Worker<{ analysisId: string }>(QUEUE, processJob, {
      connection: redisConnection,
      concurrency: 4,
    });
    worker.on('failed', (job, err) =>
      console.error(`[analysis] job ${job?.id} failed:`, err.message),
    );
  }
  return worker;
}
