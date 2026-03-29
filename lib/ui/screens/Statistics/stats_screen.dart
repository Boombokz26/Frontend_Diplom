import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../services/analytics_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final service = AnalyticsService();

  int selected = 0;
  bool loading = true;

  Map<String, dynamic> stats = {};
  List volume = [];
  List duration = [];
  List muscles = [];
  List prs = [];
  List exerciseVolume = [];
  List frequency = [];

  List progress = [];
  int? selectedExerciseId;

  @override
  void initState() {
    super.initState();
    load();
  }

  String getPeriod() {
    if (selected == 0) return "7d";
    if (selected == 1) return "30d";
    return "6m";
  }

  String getPeriodLabel() {
    if (selected == 0) return "Last 7 days";
    if (selected == 1) return "Last 30 days";
    return "Last 6 months";
  }

  List aggregate(List data, int chunkSize) {
    List result = [];

    for (int i = 0; i < data.length; i += chunkSize) {
      final chunk = data.skip(i).take(chunkSize).toList();

      final sum = chunk.fold(
        0.0,
            (s, e) => s + (e["value"] as num).toDouble(),
      );

      result.add({
        "label": chunk.last["label"],
        "value": sum,
      });
    }

    return result;
  }

  Future<void> load() async {
    setState(() => loading = true);

    final data = await service.getAnalytics(getPeriod());

    setState(() {
      stats = data["stats"];
      volume = data["volume"];
      duration = data["duration"];
      muscles = data["muscles"];
      prs = data["prs"];
      exerciseVolume = data["exercise_volume"];
      frequency = data["frequency"];

      if (prs.isNotEmpty) {
        if (!prs.any((e) => e["exercise_id"] == selectedExerciseId)) {
          selectedExerciseId = prs.first["exercise_id"];
        }
      }

      loading = false;
    });

    if (selectedExerciseId != null) {
      await loadProgress();
    }
  }

  Future<void> loadProgress() async {
    final data = await service.getExerciseProgress(selectedExerciseId!);

    setState(() {
      progress = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 20),
              _switcher(),
              const SizedBox(height: 20),
              _stats(),
              const SizedBox(height: 20),
              _card("Volume", _lineChart(volume), "${stats["total_volume"]} kg"),
              _card("Duration", _barChart(duration), "${stats["total_duration"]} min"),
              _card("Workout Frequency", _frequencyChart(), ""),
              _card("Exercise Volume", _exerciseChart(), ""),
              _card("PR Records", _prList(), ""),
              _card("Muscles", _pieChart(), "Distribution"),
              _card("Exercise Progress", _progressSection(), ""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B6CFF), Color(0xFF8E44AD)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Analytics",
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text("Your training progress", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _switcher() {
    final labels = ["7D", "30D", "6M"];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = selected == i;

          return Expanded(
            child: GestureDetector(
              onTap: () async {
                setState(() => selected = i);
                await load();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF5B6CFF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(labels[i],
                      style: TextStyle(
                          color: active ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _stats() {
    return Row(
      children: [
        _statCard("Workouts", "${stats["total_workouts"]}"),
        const SizedBox(width: 12),
        _statCard("Volume", "${stats["total_volume"]}"),
        const SizedBox(width: 12),
        _statCard("Time", "${stats["total_duration"]}m"),
      ],
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, Widget chart, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (value.isNotEmpty)
            Text(getPeriodLabel(), style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 14),
          chart,
          if (value.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _progressSection() {
    return Column(
      children: [
        DropdownButton<int>(
          value: prs.isEmpty
              ? null
              : prs.any((e) => e["exercise_id"] == selectedExerciseId)
              ? selectedExerciseId
              : prs.first["exercise_id"],
          isExpanded: true,
          hint: const Text("Select exercise"),
          items: prs.map<DropdownMenuItem<int>>((e) {
            return DropdownMenuItem<int>(
              value: e["exercise_id"],
              child: Text(e["exercise"]),
            );
          }).toList(),
          onChanged: (v) async {
            if (v == null) return;
            setState(() => selectedExerciseId = v);
            await loadProgress();
          },
        ),
        const SizedBox(height: 12),
        _progressChart(),
      ],
    );
  }

  Widget _progressChart() {
    if (progress.isEmpty) {
      return const SizedBox(height: 140, child: Center(child: Text("No data")));
    }

    final spots = List.generate(
      progress.length,
          (i) => FlSpot(
        i.toDouble(),
        (progress[i]["value"] as num).toDouble(),
      ),
    );

    final labels = progress.map((e) => e["date"].toString()).toList();

    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: 0,
          maxY: maxY == 0 ? 10 : maxY,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (labels.length / 3).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  int i = value.toInt();
                  if (i < 0 || i >= labels.length) return const SizedBox();
                  final date = labels[i].substring(5, 10);
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF5B6CFF), Color(0xFF8E44AD)],
              ),
              barWidth: 4,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lineChart(List data) {
    List processed = data;

    if (selected == 1) {
      processed = aggregate(data, 3);
    } else if (selected == 2) {
      processed = aggregate(data, 7);
    }

    if (processed.isEmpty) {
      return const SizedBox(height: 140, child: Center(child: Text("No data")));
    }

    final labels = processed.map((e) => e["label"].toString()).toList();

    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: _titles(labels, processed),
          minX: 0,
          maxX: (processed.length - 1).toDouble(),
          minY: 0,
          maxY: processed.map((e) => (e["value"] as num).toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                processed.length,
                    (i) => FlSpot(i.toDouble(), (processed[i]["value"] as num).toDouble()),
              ),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Color(0xFF5B6CFF), Color(0xFF8E44AD)],
              ),
              barWidth: 4,
              dotData: const FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }

  Widget _barChart(List data) {
    List processed = data;

    if (selected == 1) {
      processed = aggregate(data, 3);
    } else if (selected == 2) {
      processed = aggregate(data, 7);
    }

    if (processed.isEmpty) {
      return const SizedBox(height: 140, child: Center(child: Text("No data")));
    }

    final labels = processed.map((e) => e["label"].toString()).toList();

    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          borderData: FlBorderData(show: false),
          titlesData: _titles(labels, processed),
          maxY: processed.map((e) => (e["value"] as num).toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
          barGroups: List.generate(processed.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (processed[i]["value"] as num).toDouble(),
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _frequencyChart() {
    List processed = frequency;

    if (selected == 1) {
      processed = aggregate(frequency, 3);
    } else if (selected == 2) {
      processed = aggregate(frequency, 7);
    }

    if (processed.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text("No data")));
    }

    final labels = processed.map((e) => e["label"].toString()).toList();

    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          titlesData: _titles(labels, processed),
          borderData: FlBorderData(show: false),
          maxY: processed.map((e) => (e["value"] as num).toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
          barGroups: List.generate(processed.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (processed[i]["value"] as num).toDouble(),
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _exerciseChart() {
    final max = exerciseVolume.isEmpty
        ? 1
        : exerciseVolume.map((e) => e["value"] as num).reduce((a, b) => a > b ? a : b);

    return Column(
      children: exerciseVolume.map((e) {
        final value = e["value"];
        final percent = value / max;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e["label"]),
                  Text("$value kg", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 10,
                  color: Colors.grey.shade200,
                  child: FractionallySizedBox(
                    widthFactor: percent.toDouble(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF5B6CFF), Color(0xFF8E44AD)],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _prList() {
    return Column(
      children: prs.map((e) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(e["exercise"]),
          trailing: Text(
            "${e["max_weight"]} kg",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _pieChart() {
    final sorted = [...muscles]
      ..sort((a, b) => (b["value"] as num).compareTo(a["value"] as num));

    final top = sorted.take(4).toList();

    final total = sorted.fold(0.0, (sum, e) => sum + (e["value"] as num));

    final otherSum = sorted.skip(4).fold(0.0, (sum, e) => sum + (e["value"] as num));

    if (otherSum > 0) {
      top.add({"label": "Other", "value": otherSum});
    }

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PieChart(
            PieChartData(
              sections: List.generate(top.length, (i) {
                final m = top[i];
                return PieChartSectionData(
                  value: (m["value"] as num).toDouble(),
                  color: Colors.primaries[i % Colors.primaries.length],
                  radius: 40,
                  title: "",
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(top.length, (i) {
            final m = top[i];
            final color = Colors.primaries[i % Colors.primaries.length];

            final percent = total == 0 ? 0 : ((m["value"] as num) / total * 100);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(m["label"])),
                  Text(
                    "${percent.toStringAsFixed(0)}%",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  FlTitlesData _titles(List<String> labels, List data) {
    final values = data.isEmpty
        ? [0.0]
        : data.map((e) => (e["value"] as num).toDouble()).toList();

    final maxY = values.reduce((a, b) => a > b ? a : b);
    final interval = (maxY / 3).ceilToDouble();

    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 36,
          interval: interval == 0 ? 1 : interval,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: (labels.length / 3).ceilToDouble(),
          getTitlesWidget: (value, meta) {
            int i = value.toInt();
            if (i < 0 || i >= labels.length) return const SizedBox();

            final text = labels[i];

            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Transform.rotate(
                angle: -0.5,
                child: Text(
                  text.length > 5 ? text.substring(0, 5) : text,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}