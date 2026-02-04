import 'package:flutter/material.dart';
import '../common/app_widgets.dart';
import '../common/top_titles.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      WorkoutProgram(
        title: 'Upper Body Strength',
        tagText: 'Upper Body',
        tagBg: Color(0xFFD9FBF2),
        tagFg: Color(0xFF009B87),
        exercises: 6,
        minutes: '45-60 min',
      ),
      WorkoutProgram(
        title: 'Lower Body Power',
        tagText: 'Legs',
        tagBg: Color(0xFFF1E6FF),
        tagFg: Color(0xFF8E2BFF),
        exercises: 5,
        minutes: '50-65 min',
      ),
      WorkoutProgram(
        title: 'Full Body Workout',
        tagText: 'Full Body',
        tagBg: Color(0xFFDCEBFF),
        tagFg: Color(0xFF2563EB),
        exercises: 8,
        minutes: '60-75 min',
      ),
      WorkoutProgram(
        title: 'Push Day',
        tagText: 'Upper Body',
        tagBg: Color(0xFFD9FBF2),
        tagFg: Color(0xFF009B87),
        exercises: 5,
        minutes: '40-50 min',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      children: [
        const TopTitle(title: 'Workouts', subtitle: 'Your training programs'),
        const SizedBox(height: 18),
        ...items.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: WorkoutProgramCard(program: p),
        )),
      ],
    );
  }
}

class WorkoutProgram {
  final String title;
  final String tagText;
  final Color tagBg;
  final Color tagFg;
  final int exercises;
  final String minutes;

  const WorkoutProgram({
    required this.title,
    required this.tagText,
    required this.tagBg,
    required this.tagFg,
    required this.exercises,
    required this.minutes,
  });
}

class WorkoutProgramCard extends StatelessWidget {
  final WorkoutProgram program;

  const WorkoutProgramCard({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 30, color: Color(0xFF9CA3AF)),
            ],
          ),
          const SizedBox(height: 10),
          Pill(text: program.tagText, bg: program.tagBg, fg: program.tagFg),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.fitness_center, size: 20, color: Color(0xFF64748B)),
              const SizedBox(width: 10),
              Text(
                '${program.exercises} exercises',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.schedule_rounded, size: 20, color: Color(0xFF64748B)),
              const SizedBox(width: 10),
              Text(
                program.minutes,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
