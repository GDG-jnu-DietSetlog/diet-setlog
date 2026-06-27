import { randomUUID } from 'node:crypto';
import { Storage } from '@google-cloud/storage';
import { env } from '../env.js';

// Google Cloud Storage. 로컬은 fake-gcs-server 에뮬레이터(GCS_API_ENDPOINT 설정 시).
// 실제 GCS는 GOOGLE_APPLICATION_CREDENTIALS(서비스계정)로 인증.
const storage = new Storage({
  projectId: env.GCS_PROJECT_ID,
  ...(env.GCS_API_ENDPOINT ? { apiEndpoint: env.GCS_API_ENDPOINT } : {}),
});

const bucket = storage.bucket(env.GCS_BUCKET);

const EXT: Record<string, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/webp': 'webp',
};

// 버킷 없으면 생성(부팅 시 호출). 에뮬레이터 기동 대기 위해 재시도.
export async function ensureBucket(retries = 10): Promise<void> {
  for (let i = 0; ; i++) {
    try {
      const [exists] = await bucket.exists();
      if (!exists) await bucket.create();
      return;
    } catch (e) {
      if (i >= retries) throw e;
      await new Promise((r) => setTimeout(r, 1000));
    }
  }
}

export interface UploadResult {
  key: string;
  url: string;
}

export async function uploadImage(buffer: Buffer, contentType: string): Promise<UploadResult> {
  const key = `analyses/${randomUUID()}.${EXT[contentType] ?? 'bin'}`;
  await bucket.file(key).save(buffer, { contentType, resumable: false });
  return { key, url: `${env.GCS_PUBLIC_URL}/${env.GCS_BUCKET}/${key}` };
}

export async function getObjectBuffer(key: string): Promise<Buffer> {
  const [buf] = await bucket.file(key).download();
  return buf;
}
