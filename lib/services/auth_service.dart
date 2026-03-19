import 'package:dio/dio.dart';
import 'token_storage.dart';
import 'api_client.dart';
class AuthService {

  final dio = ApiClient().dio;

  Future<bool> login(String email, String password) async {
    try {

      final response = await dio.post(
        "/login/",
        data: {
          "email": email,
          "password": password,
        },
      );

      print("LOGIN RESPONSE:");
      print(response.data);

      final token = response.data["access"];

      await TokenStorage.saveToken(token);
      await TokenStorage.saveEmail(email);

      return true;

    } catch (e) {

      if (e is DioException) {
        print("LOGIN ERROR:");
        print(e.response?.data);
      }

      print(e);

      return false;
    }
  }

  Future<bool> register(
      String name,
      String email,
      String password,
      double height,
      double weight,
      int goalId,
      ) async {

    try {

      await dio.post(
        "/register/",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "height": height,
          "weight_current": weight,
          "goal_id": goalId
        },
      );


      return await login(email, password);

    } catch (e) {
      print(e);
      return false;
    }
  }

}