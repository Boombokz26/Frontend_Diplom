import 'package:flutter/material.dart';

class CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const CardShell({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const Pill({super.key, required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

class CircleIcon extends StatelessWidget {
  final Color bg;
  final IconData icon;
  final Color iconColor;
  final double size;

  const CircleIcon({
    super.key,
    required this.bg,
    required this.icon,
    required this.iconColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Color(0xFF334155),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const BottomNav({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const active = Color(0xFF009B87);
    const inactive = Color(0xFF9CA3AF);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: active,
        unselectedItemColor: inactive,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics),
            label: "Exercises",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class VLine extends StatelessWidget {
  const VLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFE5E7EB),
    );
  }
}
class SettingsTile extends StatelessWidget {

  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return CardShell(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Row(
          children: [

            CircleIcon(
              bg: iconBg,
              icon: icon,
              iconColor: iconColor,
              size: 56,
            ),

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

            const Icon(
              Icons.chevron_right_rounded,
              size: 30,
              color: Color(0xFF9CA3AF),
            ),

          ],
        ),
      ),
    );
  }
}