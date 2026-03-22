import 'package:flutter/material.dart';
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

      setState(() {
        duration += const Duration(seconds: 1);
      });

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

    if (total == 0) return 0;
    return done / total;
  }

  Future toggleSet(Map set) async {
    if (set["is_completed"]) {
      await workoutService.uncompleteSet(set["set_id"]);
    } else {
      await workoutService.completeSet(set["set_id"]);
    }
    loadSession();
  }

  Future updateSet(int setId, {int? reps, int? weight}) async {
    await workoutService.updateSet(
      setId: setId,
      reps: reps,
      weight: weight,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
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


                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),

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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                      )
                    ],
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


                      ...e["sets"].map<Widget>((set) {
                        final isDone = set["is_completed"];

                        return GestureDetector(
                          onTap: () => toggleSet(set),

                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: isDone
                                  ? Colors.green.withOpacity(.15)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDone
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                            ),

                            child: Row(
                              children: [


                                AnimatedSwitcher(
                                  duration:
                                  const Duration(milliseconds: 200),
                                  child: Icon(
                                    isDone
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    key: ValueKey(isDone),
                                    color: isDone
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Text("Set ${set["set_number"]}"),

                                const Spacer(),


                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue:
                                    set["weight"].toString(),
                                    textAlign: TextAlign.center,
                                    keyboardType:
                                    TextInputType.number,
                                    onFieldSubmitted: (v) =>
                                        updateSet(
                                          set["set_id"],
                                          weight: int.tryParse(v),
                                        ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "kg",
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),


                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue:
                                    set["reps"].toString(),
                                    textAlign: TextAlign.center,
                                    keyboardType:
                                    TextInputType.number,
                                    onFieldSubmitted: (v) =>
                                        updateSet(
                                          set["set_id"],
                                          reps: int.tryParse(v),
                                        ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "reps",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList()
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
                onTapDown: (_) => setState(() {}),
                onTapUp: (_) async {
                  await workoutService.finishWorkout(widget.sessionId);
                  Navigator.pop(context);
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.teal],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
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