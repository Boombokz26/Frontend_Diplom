import 'package:flutter/material.dart';
import '../common/app_widgets.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final Map workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(workout["plan_name"]),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CardShell(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat("Volume", "${workout["total_volume"]} kg"),
                _stat("Time", "${workout["duration"]} min"),
                _stat("Exercises",
                    "${workout["exercises"].length}"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...workout["exercises"].map<Widget>((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CardShell(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            e["name"],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text("${e["volume"].toInt()} kg"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...e["sets"].map<Widget>((s) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: s["is_completed"]
                              ? Colors.green.withOpacity(.1)
                              : Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              s["is_completed"]
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: s["is_completed"]
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Text("Set ${s["set_number"]}"),
                            const Spacer(),
                            Text("${s["weight"]} kg"),
                            const SizedBox(width: 10),
                            Text("${s["reps"]} reps"),
                          ],
                        ),
                      );
                    }).toList()
                  ],
                ),
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  Widget _stat(String title, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title,
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}