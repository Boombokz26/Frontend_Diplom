import 'package:flutter/material.dart';
import '../../../services/workout_service.dart';
import '../../../services/goals_service.dart';

class CreateWorkoutPlanScreen extends StatefulWidget {
  const CreateWorkoutPlanScreen({super.key});

  @override
  State<CreateWorkoutPlanScreen> createState() =>
      _CreateWorkoutPlanScreenState();
}

class _CreateWorkoutPlanScreenState extends State<CreateWorkoutPlanScreen> {

  final WorkoutService workoutService = WorkoutService();
  final GoalsService goalsService = GoalsService();

  final TextEditingController nameController = TextEditingController();

  List goals = [];
  int? selectedGoal;

  bool isLoading = false;
  bool isLoadingGoals = true;

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  Future loadGoals() async {

    try {

      final data = await goalsService.getGoals();

      setState(() {
        goals = data;
        selectedGoal = goals.first["id"];
        isLoadingGoals = false;
      });

    } catch (e) {
      print(e);
    }

  }

  Future<void> createPlan() async {

    if (nameController.text.isEmpty || selectedGoal == null) return;

    setState(() {
      isLoading = true;
    });

    try {

      await workoutService.createWorkoutPlan(
        name: nameController.text,
        goal: selectedGoal!,
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creating plan")),
      );

    }

    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    if (isLoadingGoals) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create workout plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Plan name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Example: Push Day",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Goal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField(
              value: selectedGoal,
              items: goals.map((goal) {

                return DropdownMenuItem(
                  value: goal["id"],
                  child: Text(goal["name"]),
                );

              }).toList(),
              onChanged: (value) {

                setState(() {
                  selectedGoal = value as int;
                });

              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : createPlan,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Create plan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}