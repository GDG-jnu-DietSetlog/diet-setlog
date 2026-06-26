import { PrismaClient } from '@prisma/client';

// 파일럿 최소 seed. 추천용 30명 seed(spec-lock §8)는 friends 모듈 wave에서 확장.
const prisma = new PrismaClient();

async function main() {
  await prisma.user.upsert({
    where: { id: '00000000-0000-0000-0000-000000000001' },
    update: {},
    create: { id: '00000000-0000-0000-0000-000000000001', displayName: 'seed-demo', isGuest: false },
  });
  console.log('seed: ok');
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
