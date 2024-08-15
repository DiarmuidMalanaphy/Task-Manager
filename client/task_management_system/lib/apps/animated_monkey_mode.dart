import 'dart:math' as math;
import 'package:flutter/material.dart';

class MonkeyModeBackground extends StatelessWidget {
  final double animationValue;

  MonkeyModeBackground({required this.animationValue});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MonkeyModeBackgroundPainter(animationValue),
      child: Container(),
    );
  }
}

class MonkeyModeBackgroundPainter extends CustomPainter {
  final double animationValue;
  final List<SwingingMonkey> monkeys = [];
  final List<FallingBanana> bananas = [];
  final math.Random random = math.Random();

  MonkeyModeBackgroundPainter(this.animationValue) {
    _initializeMonkeys();
    _initializeBananas();
  }

  void _initializeMonkeys() {
    for (int i = 0; i < 5; i++) {
      monkeys.add(SwingingMonkey(
        x: random.nextDouble(),
        y: random.nextDouble() * 0.4,
        swingAmplitude: random.nextDouble() * 0.2 + 0.1,
        swingFrequency: random.nextDouble() * 2 + 1,
      ));
    }
  }

  void _initializeBananas() {
    for (int i = 0; i < 10; i++) {
      bananas.add(FallingBanana(
        x: random.nextDouble(),
        y: random.nextDouble() * -1.5,
        fallSpeed: random.nextDouble() * 0.3 + 0.1,
        rotationSpeed: random.nextDouble() * 3 + 2,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawJungleElements(canvas, size);
    _drawMonkeys(canvas, size);
    _drawBananas(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
  }

  void _drawJungleElements(Canvas canvas, Size size) {
    final leafPaint = Paint()..color = Color(0xFF81C784);
    final palmPaint = Paint()..color = Color(0xFF4CAF50);
    final palmPath = Path();

    // Draw leaves
    for (int i = 0; i < 30; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(random.nextDouble() * 2 * math.pi);
      canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: 50, height: 25),
          leafPaint);
      canvas.restore();
    }

    // Draw palm trees
    for (int i = 0; i < 4; i++) {
      double x = random.nextDouble() * size.width;
      double y = size.height * (0.5 + random.nextDouble() * 0.4);
      canvas.drawRect(Rect.fromLTWH(x, y, 15, size.height * 0.3), palmPaint);

      palmPath
        ..reset()
        ..moveTo(x + 7.5, y)
        ..relativeLineTo(-20, -30)
        ..relativeLineTo(40, 0)
        ..close();

      canvas.drawPath(palmPath, leafPaint);
    }
  }

  void _drawMonkeys(Canvas canvas, Size size) {
    for (var monkey in monkeys) {
      _drawMonkey(canvas, size, monkey);
    }
  }

  void _drawMonkey(Canvas canvas, Size size, SwingingMonkey monkey) {
    final bodyPaint = Paint()..color = Color(0xFF6D4C41);
    final facePaint = Paint()..color = Color(0xFFBCAAA4);
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double x = monkey.x * size.width;
    double y = monkey.y * size.height +
        math.sin(animationValue * monkey.swingFrequency * 2 * math.pi) *
            monkey.swingAmplitude *
            size.height;

    // Draw body
    canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 50, height: 80),
        bodyPaint);

    // Draw head
    canvas.drawCircle(Offset(x, y - 50), 30, facePaint);

    // Draw eyes
    canvas.drawCircle(Offset(x - 10, y - 55), 8, eyePaint);
    canvas.drawCircle(Offset(x + 10, y - 55), 8, eyePaint);

    // Draw pupils
    canvas.drawCircle(Offset(x - 10, y - 55), 4, pupilPaint);
    canvas.drawCircle(Offset(x + 10, y - 55), 4, pupilPaint);

    // Draw smile
    canvas.drawArc(Rect.fromCircle(center: Offset(x, y - 40), radius: 20),
        0.2 * math.pi, 0.6 * math.pi, false, smilePaint);
  }

  void _drawBananas(Canvas canvas, Size size) {
    for (var banana in bananas) {
      _drawBanana(canvas, size, banana);
    }
  }

  void _drawBanana(Canvas canvas, Size size, FallingBanana banana) {
    final paint = Paint()..color = Color(0xFFFFEB3B);

    double x = banana.x * size.width;
    double y =
        (banana.y + animationValue * banana.fallSpeed) % (size.height * 1.5) -
            size.height * 0.5;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(animationValue * banana.rotationSpeed);

    final bananaPath = Path()
      ..moveTo(0, -20)
      ..quadraticBezierTo(20, -5, 0, 20)
      ..quadraticBezierTo(-20, -5, 0, -20)
      ..close();

    canvas.drawPath(bananaPath, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MonkeyModeBackgroundPainter oldDelegate) => true;
}

class SwingingMonkey {
  final double x;
  final double y;
  final double swingAmplitude;
  final double swingFrequency;

  SwingingMonkey({
    required this.x,
    required this.y,
    required this.swingAmplitude,
    required this.swingFrequency,
  });
}

class FallingBanana {
  final double x;
  double y;
  final double fallSpeed;
  final double rotationSpeed;

  FallingBanana({
    required this.x,
    required this.y,
    required this.fallSpeed,
    required this.rotationSpeed,
  });
}
