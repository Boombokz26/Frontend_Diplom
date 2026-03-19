import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {

  final int step;
  final int total;

  const OnboardingProgress({
    super.key,
    required this.step,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Row(
          children: List.generate(total, (index) {

            final active = index < step;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF009B87)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 8),

        Text(
          "Step $step of $total",
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}