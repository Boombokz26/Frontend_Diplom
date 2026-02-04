import 'package:flutter/material.dart';

class MiniLineChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const MiniLineChart({super.key, required this.values, required this.labels})
      : assert(values.length == labels.length);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MiniLineChartPainter(values: values, labels: labels),
      child: const SizedBox.expand(),
    );
  }
}

class _MiniLineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;

  _MiniLineChartPainter({required this.values, required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    const lineColor = Color(0xFF009B87);
    const textColor = Color(0xFF9CA3AF);

    final paddingLeft = 8.0;
    final paddingRight = 8.0;
    final paddingTop = 10.0;
    final paddingBottom = 28.0;

    final chartW = size.width - paddingLeft - paddingRight;
    final chartH = size.height - paddingTop - paddingBottom;

    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.0001 ? 1.0 : (maxV - minV);

    Offset pointAt(int i) {
      final x = paddingLeft + (chartW * i / (values.length - 1));
      final norm = (values[i] - minV) / range;
      final y = paddingTop + (chartH * (1 - norm));
      return Offset(x, y);
    }

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        final prev = pointAt(i - 1);
        final cx = (prev.dx + p.dx) / 2;
        path.cubicTo(cx, prev.dy, cx, p.dy, p.dx, p.dy);
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = lineColor;
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(pointAt(i), 7, dotPaint);
      canvas.drawCircle(
        pointAt(i),
        7,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final tpStyle = const TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    for (var i = 0; i < labels.length; i++) {
      if (i == 0) continue;
      final p = pointAt(i);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: tpStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, size.height - 22));
    }
  }

  @override
  bool shouldRepaint(covariant _MiniLineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.labels != labels;
  }
}
