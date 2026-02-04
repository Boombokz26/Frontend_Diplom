import 'package:flutter/material.dart';
import '../../debug/api_test_screen.dart';
import '../common/app_widgets.dart';
import '../common/top_titles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      children: [
        const TopOnlyTitle(title: 'Profile'),
        const SizedBox(height: 18),

        const ProfileCard(
          name: 'Alex Johnson',
          email: 'alex.johnson@email.com',
          levelText: 'Intermediate Level',
        ),
        const SizedBox(height: 18),

        const SectionTitle('Settings'),
        const SizedBox(height: 12),

        const SettingsTile(
          iconBg: Color(0xFFD9FBF2),
          iconColor: Color(0xFF009B87),
          icon: Icons.gps_fixed_rounded,
          title: 'Goals',
          subtitle: 'Build muscle, Gain strength',
        ),
        const SizedBox(height: 12),
        const SettingsTile(
          iconBg: Color(0xFFF1E6FF),
          iconColor: Color(0xFF8E2BFF),
          icon: Icons.scale_rounded,
          title: 'Units',
          subtitle: 'Kilograms (kg)',
        ),
        const SizedBox(height: 12),
        const SettingsTile(
          iconBg: Color(0xFFDCEBFF),
          iconColor: Color(0xFF2563EB),
          icon: Icons.dark_mode_rounded,
          title: 'Theme',
          subtitle: 'Light',
        ),
        const SizedBox(height: 18),

        const ActivityCard(workouts: '127', streak: '45', totalKg: '342k'),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ApiTestScreen()));
          },
          child: const Text('API TEST (debug)'),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String levelText;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.levelText,
  });

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Row(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: Color(0xFF009B87),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 46),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Pill(
                    text: levelText,
                    bg: const Color(0xFFD9FBF2),
                    fg: const Color(0xFF009B87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingsTile({
    super.key,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          CircleIcon(bg: iconBg, icon: icon, iconColor: iconColor, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 30, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String workouts;
  final String streak;
  final String totalKg;

  const ActivityCard({
    super.key,
    required this.workouts,
    required this.streak,
    required this.totalKg,
  });

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Activity',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ActivityStat(value: '127', label: 'Workouts')),
              VLine(),
              Expanded(child: ActivityStat(value: '45', label: 'Streak')),
              VLine(),
              Expanded(child: ActivityStat(value: '342k', label: 'Total kg')),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityStat extends StatelessWidget {
  final String value;
  final String label;

  const ActivityStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
