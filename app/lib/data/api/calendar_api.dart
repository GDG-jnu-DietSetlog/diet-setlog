import '../../core/api/dio_client.dart';
import '../models/calendar.dart';

class CalendarApi {
  CalendarApi(this._client);
  final ApiClient _client;

  /// GET /v1/calendar/daily-summary?date=YYYY-MM-DD (KST).
  Future<CalendarDayResponse> dailySummary(String date) async {
    final data = await _client.send((dio) => dio.get(
          '/calendar/daily-summary',
          queryParameters: {'date': date},
        ));
    return CalendarDayResponse.fromJson(data as Map<String, dynamic>);
  }
}
