import 'package:flutter/material.dart';
import '../../../services/exercise_service.dart';

class ExerciseSelectionScreen extends StatefulWidget {

  final String? categoryId;
  final String? goalId;

  const ExerciseSelectionScreen({
    super.key,
    this.categoryId,
    this.goalId,
  });

  @override
  State<ExerciseSelectionScreen> createState() =>
      _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState
    extends State<ExerciseSelectionScreen> {

  final ExerciseService exerciseService = ExerciseService();

  List exercises = [];
  List filtered = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {

    final data = await exerciseService.getExercises(
      categoryId: widget.categoryId,
      goalId: widget.goalId,
    );


    final cleaned = data.where((e) => e["category_name"] != null).toList();

    setState(() {
      exercises = cleaned;
      filtered = cleaned;
      isLoading = false;
    });

  }

  void search(String text) {

    setState(() {

      filtered = exercises.where((exercise) {

        final name = exercise["name"]
            .toString()
            .toLowerCase();

        return name.contains(text.toLowerCase());

      }).toList();

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Select Exercise"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [


          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search exercise",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// LIST
          Expanded(
            child: ListView.builder(

              itemCount: filtered.length,

              itemBuilder: (context, index) {

                final exercise = filtered[index];

                return ListTile(

                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.fitness_center),
                  ),

                  title: Text(
                    exercise["name"] ?? "Exercise",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "${exercise["category_name"] ?? ""} • ${exercise["DifficultyLevel"] ?? ""}",
                  ),

                  trailing: const Icon(Icons.add),

                  onTap: () {


                    Navigator.pop(
                      context,
                      exercise["exercise_id"],
                    );

                  },

                );

              },
            ),
          )

        ],
      ),
    );
  }
}