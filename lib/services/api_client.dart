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

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (e, handler) async {

          if (e.response?.statusCode == 401) {


            if (e.requestOptions.path.contains("/refresh/")) {
              await TokenStorage.clearAll();
              return handler.next(e);
            }

            final refresh = await TokenStorage.getRefresh();

            if (refresh == null) {
              await TokenStorage.clearAll();
              return handler.next(e);
            }

            try {
              final res = await dio.post(
                "/refresh/",
                data: {"refresh": refresh},
              );

              final newAccess = res.data["access"];

              await TokenStorage.saveToken(newAccess);


              final opts = e.requestOptions;
              opts.headers["Authorization"] = "Bearer $newAccess";

              final cloneReq = await dio.fetch(opts);

              return handler.resolve(cloneReq);

            } catch (err) {
              await TokenStorage.clearAll();
              return handler.next(e);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }
}