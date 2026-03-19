import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {

  final Map exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Exercise"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ICON
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF818CF8)
                ],
              ),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 70,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            exercise["name"],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Chip(
                label: Text(
                  exercise["category_name"] ?? "Other",
                ),
              ),

              const SizedBox(width: 10),

              Chip(
                label: Text(
                  exercise["DifficultyLevel"] ?? "Unknown",
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Description",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            exercise["description"] ?? "No description",
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text("Start Exercise"),
            onPressed: () {},
          )

        ],
      ),
    );
  }
}