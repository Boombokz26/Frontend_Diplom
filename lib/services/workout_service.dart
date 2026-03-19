import 'api_client.dart';

class WorkoutService {

  final dio = ApiClient().dio;


  Future<List<dynamic>> getWorkoutPlans() async {

    final response = await dio.get("/plans/");
    return response.data;

  }


  Future<void> createWorkoutPlan({
    required String name,
    required int goal,
  }) async {

    await dio.post(
      "/plans/",
      data: {
        "name": name,
        "goal": goal,
      },
    );

  }


  Future<List<dynamic>> getPlanExercises(int planId) async {

    final res = await dio.get("/plans/$planId/");
    return res.data["exercises"];

  }


  Future<void> addExercise({
    required int planId,
    required int exerciseId,
    int sets = 3,
    int reps = 10,
    int targetWeight = 0,
    int dayOfWeek = 1,
  }) async {

    await dio.post(
      "/plans/$planId/add_exercise/",
      data: {
        "exercise_id": exerciseId,
        "sets": sets,
        "reps": reps,
        "target_weight": targetWeight,
        "day_of_week": dayOfWeek
      },
    );

  }


  Future<void> updateExercise({
    required int planId,
    required int planExerciseId,
    int? sets,
    int? reps,
    int? targetWeight,
  }) async {

    await dio.patch(
      "/plans/$planId/update_exercise/",
      data: {
        "plan_exercise_id": planExerciseId,
        if (sets != null) "sets": sets,
        if (reps != null) "reps": reps,
        if (targetWeight != null) "target_weight": targetWeight,
      },
    );

  }


  Future<void> removeExercise({
    required int planId,
    required int planExerciseId,
  }) async {

    await dio.delete(
      "/plans/$planId/remove_exercise/",
      data: {
        "plan_exercise_id": planExerciseId
      },
    );

  }


  Future<void> reorderExercises({
    required int planId,
    required List<int> order,
  }) async {

    await dio.post(
      "/plans/$planId/reorder_exercises/",
      data: {
        "order": order
      },
    );

  }


  Future<void> clonePlan(int id) async {

    await dio.post("/plans/$id/clone/");

  }

}