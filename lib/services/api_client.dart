import 'package:dio/dio.dart';
import 'token_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late final Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:8000/api",
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();

          print("TOKEN IN INTERCEPTOR: $token");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }
}