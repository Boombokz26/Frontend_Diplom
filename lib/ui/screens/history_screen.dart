import 'package:flutter/material.dart';
import '../../../services/workout_service.dart';
import '../common/app_widgets.dart';
import 'workout_details_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final service = WorkoutService();

  List data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    final res = await service.getWorkoutHistory();
    setState(() {
      data = res;
      loading = false;
    });
  }

  Color getColor(double volume) {
    if (volume > 4000) return Colors.green;
    if (volume > 2000) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Your workouts",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, i) {
                final w = data[i];
                final volume = (w["total_volume"] ?? 0).toDouble();
                final color = getColor(volume);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              WorkoutDetailsScreen(workout: w),
                        ),
                      );
                    },
                    child: CardShell(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleIcon(
                                bg: color.withOpacity(0.15),
                                icon: Icons.fitness_center,
                                iconColor: color,
                                size: 40,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      w["plan_name"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      w["date"],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Pill(
                                text: "${volume.toInt()} kg",
                                bg: color.withOpacity(.15),
                                fg: color,
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("${w["duration"]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Text("min",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              const VLine(),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                        "${w["exercises"].length}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Text("exercises",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}