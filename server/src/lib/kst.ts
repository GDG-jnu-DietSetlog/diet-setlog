// spec-lock §5.1: 타임존 KST 고정. "오늘"은 Asia/Seoul 로컬 날짜.
const KST_OFFSET_MS = 9 * 60 * 60 * 1000;

// 현재 KST 로컬 날짜. iso='YYYY-MM-DD', date=해당 날짜의 UTC 자정(@db.Date 비교용).
export function kstToday(now: Date = new Date()): { iso: string; date: Date } {
  return kstLocalDate(now);
}

// 임의 시각(UTC)의 KST 로컬 날짜.
export function kstLocalDate(instant: Date): { iso: string; date: Date } {
  const shifted = new Date(instant.getTime() + KST_OFFSET_MS);
  const y = shifted.getUTCFullYear();
  const m = shifted.getUTCMonth();
  const d = shifted.getUTCDate();
  const iso = `${y}-${String(m + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
  return { iso, date: new Date(Date.UTC(y, m, d)) };
}
