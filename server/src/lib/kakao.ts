import { AppError } from '../http/errors.js';

// 카카오 로그인 검증 — api-db-design §1.5.
// 앱이 카카오 SDK 로그인으로 받은 accessToken 을 그대로 전달하면,
// 서버가 카카오 사용자 정보 API 로 검증해 고유 id/프로필을 얻는다.
// accessToken 자체가 인증 수단이라 서버 측 카카오 시크릿은 필요 없다.

export interface KakaoProfile {
  kakaoId: string;
  nickname: string | null;
  profileImageUrl: string | null;
}

const KAKAO_ME_URL = 'https://kapi.kakao.com/v2/user/me';

interface KakaoMeResponse {
  id?: number;
  kakao_account?: {
    profile?: { nickname?: string; profile_image_url?: string };
  };
}

export async function fetchKakaoProfile(accessToken: string): Promise<KakaoProfile> {
  let res: Response;
  try {
    res = await fetch(KAKAO_ME_URL, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
    });
  } catch {
    throw new AppError('INTERNAL', 'failed to reach Kakao');
  }

  if (res.status === 401) {
    throw new AppError('UNAUTHORIZED', 'invalid or expired Kakao access token');
  }
  if (!res.ok) {
    throw new AppError('INTERNAL', `Kakao API error (${res.status})`);
  }

  const data = (await res.json()) as KakaoMeResponse;
  if (data.id == null) {
    throw new AppError('UNAUTHORIZED', 'Kakao response missing user id');
  }

  const profile = data.kakao_account?.profile;
  return {
    kakaoId: String(data.id),
    nickname: profile?.nickname?.trim() || null,
    profileImageUrl: profile?.profile_image_url ?? null,
  };
}
