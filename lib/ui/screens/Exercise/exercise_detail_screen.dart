import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Map exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final name = exercise["name"] ?? "Exercise";
    final category = exercise["category_name"] ?? "Not specified";
    final difficulty = exercise["DifficultyLevel"] ?? "Unknown";
    final description = exercise["description"] ?? "No description";

    final goalsRaw = exercise["goals"];
    List goalsList = [];

    if (goalsRaw != null && goalsRaw is List) {
      goalsList = goalsRaw;
    }

    final equipmentRaw = exercise["equipment"];
    List equipmentList = [];

    if (equipmentRaw != null && equipmentRaw is List) {
      equipmentList = equipmentRaw;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _card(
            title: "Difficulty",
            icon: Icons.speed,
            child: Text(difficulty),
          ),
          const SizedBox(height: 16),
          _card(
            title: "Goal",
            icon: Icons.flag,
            child: goalsList.isEmpty
                ? const Text("Not specified")
                : Wrap(
              spacing: 8,
              children: goalsList.map<Widget>((g) {
                return Chip(
                  label: Text(g.toString()),
                  backgroundColor:
                  Colors.deepPurple.withValues(alpha: 0.1),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _card(
            title: "Equipment",
            icon: Icons.build,
            child: equipmentList.isEmpty
                ? const Text("Not specified")
                : Wrap(
              spacing: 8,
              children: equipmentList.map<Widget>((e) {
                return Chip(
                  label: Text(e.toString()),
                  backgroundColor:
                  Colors.blue.withValues(alpha: 0.1),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _card(
            title: "Muscle Group",
            icon: Icons.accessibility_new,
            child: Text(category),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          )
        ],
      ),
    );
  }
}