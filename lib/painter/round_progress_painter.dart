import 'dart:math';

import 'package:flutter/material.dart';

class RoundProgressPainter extends CustomPainter {
  final Color color;
  final double progress;

  RoundProgressPainter(this.color, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..color = color;
    // 画圆弧
    canvas.drawArc(
        Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2),
        -pi / 2, // 起点是-90°
        pi * 2 * progress, // 进度*360°
        false,
        paint);
    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
