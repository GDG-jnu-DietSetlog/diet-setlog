#!/usr/bin/env bash
set -e

# 마이그레이션 적용(배포용 — 스키마 변경 없이 기존 마이그레이션만 적용)
echo "[entrypoint] prisma migrate deploy"
npx prisma migrate deploy

echo "[entrypoint] starting server"
exec node dist/index.js
