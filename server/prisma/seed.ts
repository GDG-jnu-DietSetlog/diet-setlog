import { PrismaClient, type GoalDir, type Gender } from '@prisma/client';

// 추천 폴백 검증용 seed 30명 — spec-lock §8.
// 목표방향 lose:maintain:gain ≈ 5:2:3, ageBucket 1980~2000, postCount/lastPostedAt 분산.
const prisma = new PrismaClient();

const DIRS: GoalDir[] = ['lose', 'lose', 'lose', 'lose', 'lose', 'maintain', 'maintain', 'gain', 'gain', 'gain'];
const GENDERS: Gender[] = ['male', 'female', 'other'];

async function main() {
  for (let i = 0; i < 30; i++) {
    const id = `00000000-0000-0000-0000-0000000000${String(i).padStart(2, '0')}`;
    const dir = DIRS[i % DIRS.length]!;
    const birthYear = 1980 + (i % 21); // 1980~2000
    const ageBucket = Math.floor(birthYear / 10) * 10;
    const postCount = 1 + ((i * 3) % 30);
    const daysAgo = i % 14;
    const lastPostedAt = new Date(Date.UTC(2026, 5, 26) - daysAgo * 86400_000);
    const weeklyWeightDelta = dir === 'lose' ? -0.3 - (i % 3) * 0.1 : dir === 'gain' ? 0.2 + (i % 3) * 0.1 : 0;
    const dailyCalorieTarget = 1500 + (i % 8) * 100;

    await prisma.user.upsert({
      where: { id },
      update: {},
      create: {
        id,
        displayName: `seed-${String(i).padStart(2, '0')}`,
        isGuest: false,
        goalDirection: dir,
        ageBucket,
        postCount,
        lastPostedAt,
        followerCount: i % 7,
        followingCount: i % 4,
        profile: {
          create: {
            gender: GENDERS[i % 3]!,
            birthYear,
            heightCm: 160 + (i % 30),
            currentWeightKg: 60 + (i % 25),
            targetWeightKg: 58 + (i % 20),
            targetDate: new Date(Date.UTC(2026, 11, 1)),
            dailyCalorieTarget,
            weeklyWeightDelta,
          },
        },
      },
    });
  }
  console.log('seed: 30 users ok');
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
