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


  Future<List<Map<String, dynamic>>> getExerciseProgress(int exerciseId) async {
    final res = await dio.get(
      "/stats/exercise/$exerciseId/",
    );

    return List<Map<String, dynamic>>.from(res.data);
  }


  Future<Map<String, dynamic>> getOneRepMax(int exerciseId) async {
    final res = await dio.get(
      "/stats/1rm/$exerciseId/",
    );

    return res.data;
  }
}