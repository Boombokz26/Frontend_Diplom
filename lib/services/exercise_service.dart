import 'api_client.dart';

class ExerciseService {

  final ApiClient api = ApiClient();

  Future<List> getExercises({
    String? categoryId,
    String? goalId,
  }) async {

    Map<String, dynamic> params = {};

    if (categoryId != null) {
      params["category_id"] = categoryId;
    }

    if (goalId != null) {
      params["goal_id"] = goalId;
    }

    final res = await api.dio.get(
      "/exercises/",
      queryParameters: params,
    );


    return (res.data as List).map((e) {
      return {
        ...e,
        "DifficultyLevel": e["DifficultyLevel"] ?? "",
        "equipment": e["equipment"] ?? [],
      };
    }).toList();
  }

}