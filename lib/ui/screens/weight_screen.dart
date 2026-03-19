import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../common/onboarding_progress.dart';
import 'goal_screen.dart';
import '../../models/onboarding_data.dart';


class WeightScreen extends StatefulWidget {

  final OnboardingData data;

  const WeightScreen({
    super.key,
    required this.data,
  });

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {

  final auth = AuthService();
  int selectedWeight = 70;

  @override
  Widget build(BuildContext context) {

    final weights = List.generate(271, (i) => i + 30);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      appBar: AppBar(
        title: const Text("Your Weight"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          const Text(
            "Select your weight",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),

          const OnboardingProgress(
            step: 3,
            total: 4,
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [

                ListWheelScrollView.useDelegate(
                  itemExtent: 70,
                  diameterRatio: 1.4,
                  perspective: 0.005,
                  physics: const FixedExtentScrollPhysics(),

                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedWeight = weights[index];
                    });
                  },

                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: weights.length,
                    builder: (context, index) {

                      final weight = weights[index];
                      final selected = weight == selectedWeight;

                      return Center(
                        child: Text(
                          "$weight kg",
                          style: TextStyle(
                            fontSize: selected ? 36 : 24,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? const Color(0xFF009B87)
                                : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: const Color(0xFF009B87).withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

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
                  widget.data.weight = selectedWeight.toDouble();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GoalScreen(
                        data: widget.data,
                      ),
                    ),
                  );

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