import 'package:flutter/material.dart';

class RoundBasePainter extends CustomPainter {
  final Color color;

  RoundBasePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..color = color;
    //画进度条圆框背景
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    //保存画布状态
    canvas.save();
    //恢复画布状态
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
