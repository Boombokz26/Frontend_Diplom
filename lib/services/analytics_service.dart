import 'package:dio/dio.dart';
import 'api_client.dart';

class AnalyticsService {
  final Dio dio = ApiClient().dio;

  Future<Map<String, dynamic>> getAnalytics(String period) async {
    try {
      final res = await dio.get(
        "/analytics/",
        queryParameters: {"period": period},
      );

      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      throw Exception("Failed to load analytics");
    }
  }

  Future<List<Map<String, dynamic>>> getExerciseProgress(int exerciseId) async {
    try {
      final res = await dio.get("/stats/exercise/$exerciseId/");

      return (res.data as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      throw Exception("Failed to load progress");
    }
  }

  Future<Map<String, dynamic>> getOneRepMax(int exerciseId) async {
    try {
      final res = await dio.get("/stats/1rm/$exerciseId/");
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      throw Exception("Failed to load 1RM");
    }
  }

  Future<Map<String, dynamic>> getWeightAnalytics(String period) async {
    try {
      final res = await dio.get(
        "/weight/analytics/",
        queryParameters: {"period": period},
      );

      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      throw Exception("Failed to load weight analytics");
    }
  }
}