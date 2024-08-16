import 'dart:math' as math;
import 'package:flutter/material.dart';

class MonkeyModeBackground extends StatefulWidget {
  @override
  _MonkeyModeBackgroundState createState() => _MonkeyModeBackgroundState();
}

class _MonkeyModeBackgroundState extends State<MonkeyModeBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MonkeyModeBackgroundPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class MonkeyModeBackgroundPainter extends CustomPainter {
  final double animationValue;

  MonkeyModeBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw jungle background
    _drawJungleBackground(canvas, size);

    // Draw monkeys swinging from tree to tree
    _drawMonkeys(canvas, size);

    // Draw bananas in the trees
    _drawBananasInTrees(canvas, size);
  }

  void _drawJungleBackground(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = Colors.green[800]!;
    final Paint treeTrunkPaint = Paint()..color = Colors.brown;
    final Paint foliagePaint = Paint()..color = Colors.green;

    // Background
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw some trees
    for (int i = 0; i < 4; i++) {
      double treeX = (i + 1) * size.width / 5;
      canvas.drawRect(
          Rect.fromLTWH(treeX - 10, size.height / 2, 20, size.height / 2),
          treeTrunkPaint);
      canvas.drawCircle(Offset(treeX, size.height / 2), 80, foliagePaint);
    }
  }

  void _drawMonkeys(Canvas canvas, Size size) {
    final Paint monkeyBodyPaint = Paint()..color = Colors.brown[800]!;
    final Paint monkeyFacePaint = Paint()..color = Colors.brown[400]!;

    final int monkeyCount = 3; // Reduced to match tree count
    final double monkeySize = 40.0;

    for (int i = 0; i < monkeyCount; i++) {
      double treeStartX = (i + 1) * size.width / 5;
      double treeEndX = (i + 2) * size.width / 5;

      // Calculate swing path
      double t = animationValue;
      double x = treeStartX + (treeEndX - treeStartX) * t;
      double y = size.height / 2 + 100 * math.sin(t * math.pi); // Swing arc

      // Draw monkey body
      canvas.drawCircle(Offset(x, y), monkeySize, monkeyBodyPaint);

      // Draw monkey face
      canvas.drawCircle(Offset(x, y - 15), monkeySize / 2, monkeyFacePaint);

      // Draw monkey eyes
      canvas.drawCircle(
          Offset(x - 10, y - 20), 5, Paint()..color = Colors.black);
      canvas.drawCircle(
          Offset(x + 10, y - 20), 5, Paint()..color = Colors.black);

      // Draw monkey smile
      canvas.drawArc(
          Rect.fromCenter(center: Offset(x, y - 5), width: 20, height: 10),
          0,
          math.pi,
          false,
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
  }

  void _drawBananasInTrees(Canvas canvas, Size size) {
    final Paint bananaPaint = Paint()..color = Colors.yellow;

    for (int i = 0; i < 4; i++) {
      double treeX = (i + 1) * size.width / 5;
      double bananaY =
          size.height / 2 - 60; // Position bananas near the top of the trees

      // Draw 2-3 bananas per tree
      for (int j = 0; j < 3; j++) {
        double bananaOffsetX =
            treeX + (j - 1) * 20; // Offset bananas horizontally
        _drawBanana(canvas, Offset(bananaOffsetX, bananaY), bananaPaint);
      }
    }
  }

  void _drawBanana(Canvas canvas, Offset position, Paint paint) {
    Path path = Path();
    path.moveTo(position.dx, position.dy);
    path.quadraticBezierTo(
        position.dx + 15, position.dy - 20, position.dx + 30, position.dy);
    path.quadraticBezierTo(
        position.dx + 15, position.dy + 20, position.dx, position.dy);
    canvas.drawPath(path, paint);

    // Draw banana stem
    canvas.drawLine(
        position,
        Offset(position.dx + 5, position.dy - 10),
        paint
          ..color = Colors.brown
          ..strokeWidth = 3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint to reflect animation changes
  }
}
