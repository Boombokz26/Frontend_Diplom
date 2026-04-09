import 'api_client.dart';

class ProfileService {
  final dio = ApiClient().dio;

  Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get("/profile/");
    return response.data;
  }

  Future<void> updateGoal(int goalId) async {
    await dio.patch("/profile/update/", data: {
      "goal_id": goalId,
    });
  }

  Future<void> addWeight(double weight) async {
    await dio.post("/weight/add/", data: {
      "weight": weight,
    });
  }


  Future<List<dynamic>> getWeights() async {
    final response = await dio.get("/weight/");
    return response.data;
  }


  Future<void> updateWeight(int id, double weight) async {
    await dio.patch("/weight/$id/", data: {
      "weight": weight,
    });
  }


  Future<void> deleteWeight(int id) async {
    await dio.delete("/weight/$id/delete/");
  }
}