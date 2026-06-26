# diet-setlog 백엔드 — 컨테이너 이미지. 백엔드 전체를 docker로 띄운다.
FROM node:22-slim

# Prisma 엔진은 openssl 필요(node:slim에는 없음).
RUN apt-get update && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 의존성 레이어 캐시
COPY package.json package-lock.json ./
RUN npm ci

# 소스 + prisma
COPY tsconfig.json ./
COPY prisma ./prisma
COPY src ./src

RUN npx prisma generate && npm run build

# 컨테이너 시작 시: 마이그레이션 적용 → 서버 기동
# (방어: 호스트가 CRLF로 체크아웃해도 컨테이너 bash가 깨지지 않게 CR 제거)
COPY docker-entrypoint.sh ./
RUN sed -i 's/\r$//' docker-entrypoint.sh
ENTRYPOINT ["bash", "docker-entrypoint.sh"]
