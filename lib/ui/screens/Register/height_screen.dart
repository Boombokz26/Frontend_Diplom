import 'package:flutter/material.dart';
import 'weight_screen.dart';
import '../../common/onboarding_progress.dart';
import '../../../models/onboarding_data.dart';

class HeightScreen extends StatefulWidget {

  final OnboardingData data;

  const HeightScreen({
    super.key,
    required this.data,
  });

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {

  int selectedHeight = 170;

  @override
  Widget build(BuildContext context) {

    final heights = List.generate(181, (i) => i + 50);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      appBar: AppBar(
        title: const Text("Your Height"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          const OnboardingProgress(
            step: 2,
            total: 4,
          ),

          const Text(
            "Select your height",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
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
                      selectedHeight = heights[index];
                    });
                  },

                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: heights.length,
                    builder: (context, index) {

                      final height = heights[index];
                      final selected = height == selectedHeight;

                      return Center(
                        child: Text(
                          "$height cm",
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
                onPressed: () {


                  widget.data.height = selectedHeight.toDouble();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeightScreen(
                        data: widget.data,
                      ),
                    ),
                  );

                },
                child: const Text(
                  "Next",
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