import 'package:flutter/material.dart';

class MiniBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const MiniBarChart({super.key, required this.values, required this.labels})
      : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MiniBarChartPainter(values: values, labels: labels),
      child: const SizedBox.expand(),
    );
  }
}

class _MiniBarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;

  _MiniBarChartPainter({required this.values, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    const barColor = Color(0xFF009B87);
    const textColor = Color(0xFF9CA3AF);

    final leftAxis = 42.0;
    final topPad = 10.0;
    final bottomPad = 32.0;
    final rightPad = 10.0;

    final chartW = size.width - leftAxis - rightPad;
    final chartH = size.height - topPad - bottomPad;

    final maxV = values.reduce((a, b) => a > b ? a : b);
    final maxVal = maxV <= 0 ? 1.0 : maxV;

    final ticks = [0, 900, 1800, 2700, 3600];

    final tickStyle = const TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    for (final t in ticks) {
      final y = topPad + chartH * (1 - (t / ticks.last));
      final tp = TextPainter(
        text: TextSpan(text: '$t', style: tickStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(leftAxis - tp.width - 8, y - tp.height / 2));

      final gridPaint = Paint()
        ..color = const Color(0x0F000000)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(leftAxis, y), Offset(size.width - rightPad, y), gridPaint);
    }

    final barCount = values.length;
    final gap = 14.0;
    final barW = (chartW - gap * (barCount - 1)) / barCount;

    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    for (var i = 0; i < values.length; i++) {
      final v = values[i];
      final h = (v / maxVal) * chartH;
      final x = leftAxis + i * (barW + gap);
      final y = topPad + (chartH - h);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barW, h),
        const Radius.circular(12),
      );
      canvas.drawRRect(rrect, paint);

      final label = labels[i];
      final tp = TextPainter(
        text: TextSpan(text: label, style: tickStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + barW / 2 - tp.width / 2, size.height - 24));
    }
  }

  @override
  bool shouldRepaint(covariant _MiniBarChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }
}
