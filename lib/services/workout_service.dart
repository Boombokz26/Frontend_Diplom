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
    required List<Map<String, dynamic>> sets,
    int? dayOfWeek,
  }) async {
    await dio.post(
      "/plans/$planId/add_exercise/",
      data: {
        "exercise_id": exerciseId,
        "sets": sets,
        if (dayOfWeek != null) "day_of_week": dayOfWeek,
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

  /// 🔥 PLAN SETS

  Future<void> updatePlanSet({
    required int setId,
    int? reps,
    int? weight,
    int? durationSec,
  }) async {
    await dio.patch(
      "/plan-sets/$setId/",
      data: {
        if (reps != null) "reps": reps,
        if (weight != null) "weight": weight,
        if (durationSec != null) "duration_sec": durationSec,
      },
    );
  }

  Future<int> addPlanSet({
    required int planExerciseId,
    int reps = 10,
    int weight = 0,
  }) async {

    final res = await dio.post(
      "/plan-exercises/$planExerciseId/add_set/",
      data: {
        "reps": reps,
        "weight": weight,
      },
    );

    return res.data["set_id"];
  }

  Future<void> deletePlanSet(int setId) async {
    await dio.delete("/plan-sets/$setId/");
  }



  Future<int> startWorkout(int planId) async {
    final res = await dio.post("/sessions/start/$planId/");
    return res.data["session_id"];
  }

  Future<Map<String, dynamic>> getSession(int sessionId) async {
    final res = await dio.get("/sessions/$sessionId/");
    return res.data;
  }

  Future<void> completeSet(int setId) async {
    await dio.patch("/sets/$setId/complete/");
  }

  Future<void> uncompleteSet(int setId) async {
    await dio.patch("/sets/$setId/uncomplete/");
  }

  Future<void> updateSet({
    required int setId,
    int? reps,
    int? weight,
  }) async {
    await dio.patch(
      "/sets/$setId/update/",
      data: {
        if (reps != null) "reps": reps,
        if (weight != null) "weight": weight,
      },
    );
  }

  Future<void> finishWorkout(int sessionId) async {
    await dio.patch("/sessions/$sessionId/finish/");
  }

  Future<int?> getActiveSession() async {
    final res = await dio.get("/sessions/active/");
    return res.data["session_id"];
  }

  Future<List<dynamic>> getWorkoutHistory() async {
    final res = await dio.get("/workouts/history/");
    return res.data;
  }

  Future<void> addSessionSet(int sessionExerciseId) async {
    await dio.post("/session-sets/$sessionExerciseId/add/");
  }

  Future<void> deleteSessionSet(int setId) async {
    await dio.delete("/session-sets/$setId/delete/");
  }


}