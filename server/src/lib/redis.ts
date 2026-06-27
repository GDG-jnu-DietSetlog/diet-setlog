import { env } from '../env.js';

// BullMQ 연결 옵션. 인스턴스 대신 옵션 객체를 넘겨 BullMQ가 내부 ioredis로 생성하게 한다
// (top-level ioredis와 bullmq 번들 ioredis의 타입 충돌 회피).
const url = new URL(env.REDIS_URL);
export const redisConnection = { host: url.hostname, port: Number(url.port || '6379') };
