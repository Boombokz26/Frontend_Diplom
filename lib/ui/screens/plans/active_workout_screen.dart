import 'package:flutter/material.dart';
import 'package:untitled1/ui/screens/plans/workout_details_screen.dart';
import '../../../services/workout_service.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final int sessionId;

  const ActiveWorkoutScreen({super.key, required this.sessionId});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final WorkoutService workoutService = WorkoutService();

  Map session = {};
  bool isLoading = true;
  Duration duration = Duration.zero;

  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    loadSession();
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      if (!isPaused) {
        setState(() {
          duration += const Duration(seconds: 1);
        });
      }

      return true;
    });
  }

  Future loadSession() async {
    final data = await workoutService.getSession(widget.sessionId);

    setState(() {
      session = data;
      isLoading = false;
    });
  }

  String formatTime() {
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  double calculateProgress() {
    final exercises = session["exercises"] ?? [];
    int total = 0;
    int done = 0;

    for (var e in exercises) {
      for (var s in e["sets"]) {
        total++;
        if (s["is_completed"]) done++;
      }
    }

    return total == 0 ? 0 : done / total;
  }

  Future toggleSet(Map set) async {
    if (isPaused) return;

    if (set["is_completed"]) {
      await workoutService.uncompleteSet(set["set_id"]);
    } else {
      await workoutService.completeSet(set["set_id"]);
    }
    await loadSession();
  }

  Future updateSet(int setId, {int? reps, int? weight}) async {
    await workoutService.updateSet(
      setId: setId,
      reps: reps,
      weight: weight,
    );
  }

  Future addSet(int sessionExerciseId) async {
    if (isPaused) return;
    await workoutService.addSessionSet(sessionExerciseId);
    await loadSession();
  }

  Future deleteSet(int setId) async {
    if (isPaused) return;
    await workoutService.deleteSessionSet(setId);
    await loadSession();
  }

  void editSetDialog(Map set) {
    if (isPaused) return;

    final repsController =
    TextEditingController(text: set["reps"]?.toString() ?? "");
    final weightController =
    TextEditingController(text: set["weight"]?.toString() ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Set ${set["set_number"]}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Reps"),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await updateSet(
                set["set_id"],
                reps: int.tryParse(repsController.text),
                weight: int.tryParse(weightController.text),
              );
              Navigator.pop(context);
              loadSession();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  Widget buildSetRow(Map set) {
    final isDone = set["is_completed"];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => toggleSet(set),
            child: Icon(
              isDone
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 30,
            child: Text(
              "${set["set_number"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Text("${set["reps"] ?? "-"}"),
          const Spacer(),
          Text("${set["weight"] ?? "-"}"),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: () => editSetDialog(set),
          ),
          IconButton(
            icon: const Icon(Icons.close,
                size: 18, color: Colors.red),
            onPressed: () => deleteSet(set["set_id"]),
          )
        ],
      ),
    );
  }

  Future finishWorkout() async {

    if (isPaused) {
      setState(() {
        isPaused = false;
      });
    }

    await workoutService.finishWorkout(widget.sessionId);

    final history = await workoutService.getWorkoutHistory();

    final workout = history.firstWhere(
          (w) => w["session_id"] == widget.sessionId,
      orElse: () => null,
    );

    if (workout == null || !mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutDetailsScreen(workout: workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final exercises = session["exercises"] ?? [];
    final progress = calculateProgress();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("Workout"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text("Workout Time",
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  formatTime(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isPaused = !isPaused;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(isPaused ? "Resume" : "Pause"),
                ),

                const SizedBox(height: 16),

                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Text(
                  "${(progress * 100).toInt()}% completed",
                  style: const TextStyle(color: Colors.white70),
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final e = exercises[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e["exercise_name"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          SizedBox(width: 40, child: Text("Set")),
                          Spacer(),
                          Text("Reps"),
                          Spacer(),
                          Text("Kg"),
                          SizedBox(width: 60),
                        ],
                      ),
                      const Divider(),
                      ...e["sets"].map<Widget>((set) {
                        return buildSetRow(set);
                      }).toList(),
                      TextButton.icon(
                        onPressed: () =>
                            addSet(e["session_exercise_id"]),
                        icon: const Icon(Icons.add),
                        label: const Text("Add Set"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: finishWorkout,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.teal],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "Finish Workout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}