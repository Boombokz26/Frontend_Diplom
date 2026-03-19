import 'api_client.dart';

class GoalsService {

  final dio = ApiClient().dio;

  Future<List<dynamic>> getGoals() async {

    final response = await dio.get("/goals/");

    return response.data;

  }

}