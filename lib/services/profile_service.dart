import 'api_client.dart';

class ProfileService {

  final dio = ApiClient().dio;

  Future<Map<String, dynamic>> getProfile() async {

    final response = await dio.get("/profile/");

    return response.data;

  }

}