import 'package:flutter/material.dart';
import '../common/app_widgets.dart';
import '../charts/mini_line_chart.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      children: const [
        _GreetingCard(name: 'Alex', subtitle: 'Ready to crush your goals today?'),
        SizedBox(height: 18),
        _TodayWorkoutCard(),
        SizedBox(height: 18),
        _Last7DaysCard(),
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _StatSmallCard(
                iconBg: Color(0xFFD9FBF2),
                iconColor: Color(0xFF04A98E),
                icon: Icons.fitness_center,
                value: '5 workouts',
                label: 'This week',
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: _StatSmallCard(
                iconBg: Color(0xFFF1E6FF),
                iconColor: Color(0xFF8E2BFF),
                icon: Icons.trending_up,
                value: '12,000 kg',
                label: 'Total lifted',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String name;
  final String subtitle;

  const _GreetingCard({required this.name, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $name',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 18,
              height: 1.25,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard();

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF04A98E);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF04A98E), Color(0xFF009B87)],
        ),
        boxShadow: [
          BoxShadow(
            color: teal.withOpacity(0.22),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Workout",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Upper Body Strength',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6FFFA),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              _TodayIcon(),
            ],
          ),
          const SizedBox(height: 18),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {},
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, size: 28, color: Color(0xFF009B87)),
                    SizedBox(width: 10),
                    Text(
                      'Start Workout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF009B87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayIcon extends StatelessWidget {
  const _TodayIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.fitness_center, color: Colors.white, size: 26),
    );
  }
}

class _Last7DaysCard extends StatelessWidget {
  const _Last7DaysCard();

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Last 7 Days',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Icon(Icons.trending_up, color: Color(0xFF009B87)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 160,
            child: MiniLineChart(
              values: [60, 20, 70, 18, 62, 78, 20],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Total volume (kg)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatSmallCard extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String value;
  final String label;

  const _StatSmallCard({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleIcon(bg: iconBg, icon: icon, iconColor: iconColor, size: 52),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
