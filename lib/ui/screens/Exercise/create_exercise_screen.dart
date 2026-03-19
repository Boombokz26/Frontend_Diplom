import 'package:flutter/material.dart';
import '../../../services/api_client.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({super.key});

  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {

  final api = ApiClient();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  String difficulty = "Beginner";

  bool loading = false;

  Future createExercise() async {

    setState(() {
      loading = true;
    });

    await api.dio.post(
      "/exercises/",
      data: {
        "name": nameController.text,
        "description": descriptionController.text,
        "DifficultyLevel": difficulty
      },
    );

    if (mounted) {
      Navigator.pop(context, true);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Exercise"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const Text(
            "Exercise Name",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Bench Press",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Describe how to perform the exercise",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Difficulty",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          DropdownButtonFormField(
            value: difficulty,
            items: const [
              DropdownMenuItem(
                value: "Beginner",
                child: Text("Beginner"),
              ),
              DropdownMenuItem(
                value: "Intermediate",
                child: Text("Intermediate"),
              ),
              DropdownMenuItem(
                value: "Advanced",
                child: Text("Advanced"),
              ),
            ],
            onChanged: (v) {
              setState(() {
                difficulty = v.toString();
              });
            },
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
            onPressed: loading ? null : createExercise,
            child: loading
                ? const CircularProgressIndicator()
                : const Text("Create Exercise"),
          )

        ],
      ),
    );
  }
}