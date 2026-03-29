import 'package:flutter/material.dart';
import '../../../services/workout_service.dart';
import '../Exercise/exercise_selection_screen.dart';
import 'active_workout_screen.dart';
import '../../../services/api_client.dart';

class WorkoutPlanDetailsScreen extends StatefulWidget {
  final int planId;
  final String title;

  const WorkoutPlanDetailsScreen({
    super.key,
    required this.planId,
    required this.title,
  });

  @override
  State<WorkoutPlanDetailsScreen> createState() =>
      _WorkoutPlanDetailsScreenState();
}

class _WorkoutPlanDetailsScreenState
    extends State<WorkoutPlanDetailsScreen> {

  final WorkoutService workoutService = WorkoutService();

  List exercises = [];
  bool isLoading = true;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final res = await ApiClient().dio.get("/plans/${widget.planId}/");
    final data = res.data;

    setState(() {
      exercises = data["exercises"];
      isOwner = data["User_id"] != null;
      isLoading = false;
    });
  }

  int get totalSets {
    int sum = 0;
    for (var e in exercises) {
      sum += (e["sets"] as List? ?? []).length;
    }
    return sum;
  }

  Future<void> addSet(Map exercise) async {
    await workoutService.addPlanSet(
      planExerciseId: exercise["plan_exercise_id"],
    );
    loadExercises();
  }

  Future<void> deleteSet(int setId) async {
    await workoutService.deletePlanSet(setId);
    loadExercises();
  }

  void showEditSetDialog(Map exercise, int setIndex) {
    final set = exercise["sets"][setIndex];
    final measureType = exercise["measure_type"] ?? "reps";

    final reps = TextEditingController(text: set["reps"]?.toString() ?? "");
    final weight = TextEditingController(text: set["weight"]?.toString() ?? "");
    final duration = TextEditingController(text: set["duration_sec"]?.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Edit Set ${setIndex + 1}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (measureType == "time")
              TextField(
                controller: duration,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Seconds"),
              )
            else ...[
              TextField(
                controller: reps,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Reps"),
              ),
              TextField(
                controller: weight,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Weight"),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await workoutService.updatePlanSet(
                setId: set["id"],
                reps: measureType == "time"
                    ? null
                    : int.tryParse(reps.text),
                weight: measureType == "time"
                    ? null
                    : int.tryParse(weight.text),
                durationSec: measureType == "time"
                    ? int.tryParse(duration.text)
                    : null,
              );

              Navigator.pop(context);
              loadExercises();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Future<void> deleteExercise(int id) async {
    await workoutService.removeExercise(
      planId: widget.planId,
      planExerciseId: id,
    );
    loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      floatingActionButton: isOwner
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add),
        onPressed: () async {
          final exerciseId = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ExerciseSelectionScreen(),
            ),
          );

          if (exerciseId != null) {
            await workoutService.addExercise(
              planId: widget.planId,
              exerciseId: exerciseId,
              sets: [
                {"reps": 10, "weight": 0},
                {"reps": 10, "weight": 0},
                {"reps": 10, "weight": 0},
              ],
            );

            loadExercises();
          }
        },
      )
          : null,

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF2563EB)],
              ),
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _Stat("$totalSets", "Sets"),
                    const SizedBox(width: 12),
                    _Stat("${exercises.length}", "Exercises"),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final sessionId =
                      await workoutService.startWorkout(
                          widget.planId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActiveWorkoutScreen(
                              sessionId: sessionId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4F46E5),
                    ),
                    child: const Text("Start Workout"),
                  ),
                ),

                if (!isOwner)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("Read only plan",
                        style: TextStyle(color: Colors.white70)),
                  )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (_, index) {
                final exercise = exercises[index];

                return ExerciseCard(
                  exercise: exercise,
                  isOwner: isOwner,
                  onDelete: () =>
                      deleteExercise(exercise["plan_exercise_id"]),
                  onEditSet: (i) =>
                      showEditSetDialog(exercise, i),
                  onAddSet: () => addSet(exercise),
                  onDeleteSet: deleteSet,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Map exercise;
  final bool isOwner;
  final VoidCallback onDelete;
  final Function(int) onEditSet;
  final VoidCallback onAddSet;
  final Function(int) onDeleteSet;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.isOwner,
    required this.onDelete,
    required this.onEditSet,
    required this.onAddSet,
    required this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    final sets = exercise["sets"] as List? ?? [];
    final measureType = exercise["measure_type"] ?? "reps";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: Text(
                  exercise["exercise_name"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOwner)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                )
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const _TableHeader("Set"),
              _TableHeader(measureType == "time" ? "Sec" : "Reps"),
              _TableHeader(measureType == "time" ? "" : "Kg"),
              const SizedBox(width: 40),
            ],
          ),

          const Divider(),

          ...List.generate(sets.length, (i) {
            final s = sets[i];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [

                  _TableCell("${i + 1}", isBold: true),

                  _TableCell(
                    measureType == "time"
                        ? "${s["duration_sec"] ?? 0}s"
                        : "${s["reps"]}",
                  ),

                  _TableCell(
                    measureType == "time"
                        ? ""
                        : "${s["weight"]}",
                  ),

                  if (isOwner)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => onEditSet(i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 20, color: Colors.red),
                          onPressed: () => onDeleteSet(s["id"]),
                        ),
                      ],
                    )
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          if (isOwner)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAddSet,
                icon: const Icon(Icons.add),
                label: const Text("Add Set"),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label,
              style:
              const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isBold;

  const _TableCell(this.text, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
    );
  }
}