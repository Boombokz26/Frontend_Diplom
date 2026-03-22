import 'package:dio/dio.dart';
import 'api_client.dart';

class AnalyticsService {
  final Dio dio = ApiClient().dio;

  Future<Map<String, dynamic>> getAnalytics(String period) async {
    final res = await dio.get(
      "/analytics/",
      queryParameters: {
        "period": period,
      },
    );

    return res.data;
  }
}