import 'package:flutter/material.dart';
import '../common/app_widgets.dart';
import '../common/top_titles.dart';
import '../charts/mini_bar_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int topTab = 0;   // Overview/By Exercise/Calendar
  int rangeTab = 0; // 7 days / 30 days / 3 months

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      children: [
        const TopTitle(title: 'Statistics', subtitle: 'Track your progress'),
        const SizedBox(height: 18),

        SegmentedTopTabs(
          index: topTab,
          onChanged: (v) => setState(() => topTab = v),
          labels: const ['Overview', 'By Exercise', 'Calendar'],
        ),
        const SizedBox(height: 16),

        SegmentedRangeTabs(
          index: rangeTab,
          onChanged: (v) => setState(() => rangeTab = v),
          labels: const ['7 Days', '30 Days', '3 Months'],
        ),
        const SizedBox(height: 16),

        const TotalVolumeBarCard(),
        const SizedBox(height: 18),

        const Row(
          children: [
            Expanded(child: MiniMetricCard(title: 'Avg. per workout', value: '2,850 kg')),
            SizedBox(width: 14),
            Expanded(child: MiniMetricCard(title: 'Total workouts', value: '24 sessions')),
          ],
        ),
      ],
    );
  }
}

class SegmentedTopTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const SegmentedTopTabs({
    super.key,
    required this.index,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: selected
                      ? const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    )
                  ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: selected ? const Color(0xFF009B87) : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SegmentedRangeTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const SegmentedRangeTabs({
    super.key,
    required this.index,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (i) {
        final selected = i == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == labels.length - 1 ? 0 : 12),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF009B87) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : const Color(0xFF334155),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class TotalVolumeBarCard extends StatelessWidget {
  const TotalVolumeBarCard({super.key});

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
                  'Total Volume',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Icon(Icons.trending_up, color: Color(0xFF009B87)),
              SizedBox(width: 8),
              Text(
                '+12%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF009B87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: MiniBarChart(
              values: [2400, 0, 3200, 0, 2800, 3600, 0],
              labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Weekly volume (kg)',
              style: TextStyle(
                fontSize: 20,
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

class MiniMetricCard extends StatelessWidget {
  final String title;
  final String value;

  const MiniMetricCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return CardShell(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
