import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../common/onboarding_progress.dart';
import '../../models/onboarding_data.dart';
import '../../app/home_shell.dart';
import '../../services/goals_service.dart';

class GoalScreen extends StatefulWidget {


  final OnboardingData data;

  const GoalScreen({
    super.key,
    required this.data,
  });

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {


  final auth = AuthService();
  final goalsService = GoalsService();

  List goals = [];
  bool loading = true;
  int selectedGoal = 1;



  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  void loadGoals() async {

    final data = await goalsService.getGoals();

    setState(() {
      goals = data;
      selectedGoal = goals.first["id"];
      loading = false;
    });

  }
  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      appBar: AppBar(
        title: const Text("Your Goal"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          const OnboardingProgress(
            step: 4,
            total: 4,
          ),

          const SizedBox(height: 20),

          const Text(
            "Select your goal",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 30),

          ...goals.map((goal) {

            final selected = selectedGoal == goal["id"];

            return GestureDetector(

              onTap: () {
                setState(() {
                  selectedGoal = goal["id"] as int;
                });
              },

              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF009B87)
                      : Colors.white,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(
                    color: selected
                        ? const Color(0xFF009B87)
                        : Colors.grey.shade300,
                  ),
                ),

                child: Row(
                  children: [

                    Expanded(
                      child: Text(
                        goal["name"].toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),

                    if (selected)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      )

                  ],
                ),
              ),
            );

          }).toList(),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009B87),
                ),

                onPressed: () async {

                  final success = await auth.register(
                      widget.data.name,
                      widget.data.email,
                      widget.data.password,
                      widget.data.height,
                      widget.data.weight,
                      selectedGoal
                  );

                  if (success) {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeShell(),
                      ),
                    );

                  }

                },

                child: const Text(
                  "Finish",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}