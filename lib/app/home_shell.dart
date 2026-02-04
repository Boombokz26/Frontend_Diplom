import 'package:flutter/material.dart';
import '../ui/common/app_widgets.dart';
import '../ui/screens/home_dashboard_screen.dart';
import '../ui/screens/workouts_screen.dart';
import '../ui/screens/stats_screen.dart';
import '../ui/screens/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeDashboardScreen(),
      WorkoutsScreen(),
      StatsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: BottomNav(
        index: _index,
        onChanged: (v) => setState(() => _index = v),
      ),
    );
  }
}
