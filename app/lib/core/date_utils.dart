/// 날짜 유틸. 서버는 date-only 를 YYYY-MM-DD(KST)로 받는다(spec-lock §5.1).
String ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// 시/분/초 제거(날짜만).
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
