import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  final bool isDarkMode;

  AnimatedBackground({this.isDarkMode = true});

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    )..repeat();
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
          painter: widget.isDarkMode
              ? DarkModeBackgroundPainter(_controller.value)
              : LightModeBackgroundPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class DarkModeBackgroundPainter extends CustomPainter {
  final double animationValue;
  final List<Star> stars = [];
  final List<Planet> planets = [];
  final Random random = Random();

  double timeSinceLastComet = 0.0;
  static const double cometInterval = 3.0; // Average seconds between comets
  static const double cometIntervalVariance = 2.0;

  DarkModeBackgroundPainter(this.animationValue) {
    final random = math.Random(42);
    for (int i = 0; i < 200; i++) {
      stars.add(Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2 + 0.5,
        color: Colors.white.withOpacity(random.nextDouble() * 0.5 + 0.5),
        twinkleSpeed: random.nextDouble() * 0.5 + 0.5,
      ));
    }

    // Random initial angles and increased orbit radii
    planets.add(Planet(0.25, Colors.orangeAccent, 0.02,
        random.nextDouble() * 2 * math.pi)); // Sun
    planets.add(Planet(0.35, Colors.grey[400]!, 0.01,
        random.nextDouble() * 2 * math.pi)); // Mercury
    planets.add(Planet(0.45, Colors.orange[200]!, 0.015,
        random.nextDouble() * 2 * math.pi)); // Venus
    planets.add(Planet(0.55, Colors.blue[200]!, 0.016,
        random.nextDouble() * 2 * math.pi)); // Earth
    planets.add(Planet(0.65, Colors.red[300]!, 0.014,
        random.nextDouble() * 2 * math.pi)); // Mars
    planets.add(Planet(0.80, Colors.orange[300]!, 0.03,
        random.nextDouble() * 2 * math.pi)); // Jupiter
    planets.add(Planet(0.95, Colors.yellow[600]!, 0.025,
        random.nextDouble() * 2 * math.pi)); // Saturn
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Darker background with a vein of dark purple
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.black, Colors.indigo[900]!],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ).createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Draw stars with twinkling effect
    for (var star in stars) {
      final twinkle =
          math.sin(animationValue * star.twinkleSpeed * 2 * math.pi) * 0.3 +
              0.7;
      final starPaint = Paint()
        ..color = star.color.withOpacity(twinkle)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(star.x * size.width, star.y * size.height),
          star.size, starPaint);
    }

    // Draw solar system with 3D effect planets
    drawSolarSystem(canvas, size);
  }

  void drawSolarSystem(Canvas canvas, Size size) {
    final solarSystemCenter = Offset(size.width * 0.1, size.height * 0.1);

    for (var planet in planets) {
      final orbitRadius = planet.orbitRadius * size.width;
      final angle =
          animationValue * 2 * math.pi * planet.speed + planet.initialAngle;
      final x = solarSystemCenter.dx + orbitRadius * math.cos(angle);
      final y = solarSystemCenter.dy + orbitRadius * math.sin(angle);

      // Calculate angle from the sun
      final angleFromSun =
          math.atan2(y - solarSystemCenter.dy, x - solarSystemCenter.dx);

      // Save the canvas state before applying transformations
      canvas.save();

      // Translate to the planet's position and rotate the canvas
      canvas.translate(x, y);

      // Correct 3D effect: Dynamic shading by flipping the center
      final gradientPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            planet.color,
            planet.color.withOpacity(0.7),
            Colors.black.withOpacity(0.3)
          ],
          stops: [0.0, 0.7, 1.0],
          // Flip the center to shade the correct side of the planet
          center: Alignment(
            -math.cos(angleFromSun),
            -math.sin(angleFromSun),
          ),
          radius: 0.8,
        ).createShader(Rect.fromCircle(
            center: Offset(0, 0), radius: planet.size * size.width));

      canvas.drawCircle(Offset(0, 0), planet.size * size.width, gradientPaint);

      // Restore the canvas to its previous state
      canvas.restore();
    }
  }

// Function to generate a noise texture shader
  Shader createNoiseTexture(double radius) {
    return RadialGradient(
      colors: [
        Colors.white.withOpacity(0.05),
        Colors.transparent,
      ],
      stops: [0.5, 1.0],
      center: Alignment(0.0, 0.0),
      radius: 0.8,
      tileMode: TileMode.mirror,
    ).createShader(Rect.fromCircle(
      center: Offset(0, 0),
      radius: radius,
    ));
  }

  @override
  bool shouldRepaint(DarkModeBackgroundPainter oldDelegate) => true;
}

class Star {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.twinkleSpeed,
  });
}

class Planet {
  final double orbitRadius;
  final Color color;
  final double size;
  final double speed;
  final double initialAngle;

  Planet(this.orbitRadius, this.color, this.size, this.initialAngle)
      : speed = 1 / orbitRadius;
}

class LightModeBackgroundPainter extends CustomPainter {
  final double animationValue;
  final int numberOfBlobs = 15;
  final List<Blob> blobs;

  LightModeBackgroundPainter(this.animationValue) : blobs = [] {
    final random = math.Random(42);
    for (int i = 0; i < numberOfBlobs; i++) {
      blobs.add(Blob(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 0.2 + 0.1,
        color: Color.fromRGBO(
          random.nextInt(156) + 100,
          random.nextInt(156) + 100,
          random.nextInt(256),
          0.4,
        ),
        speed: random.nextDouble() * 0.01 + 0.005,
        phase: random.nextDouble() * 2 * math.pi,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Cool gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.blue[100]!,
        Colors.blue[300]!,
        Colors.purple[100]!,
        Colors.purple[300]!,
      ],
      stops: [0.0, 0.4, 0.7, 1.0],
    );
    final backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Prepare blob paints with shadow
    final shadowColor = Colors.black.withOpacity(0.3);
    final shadowOffset = Offset(2, 2);

    for (var blob in blobs) {
      // Pulsating effect
      final pulse =
          (0.5 + 0.5 * math.sin(animationValue * 4 * math.pi)) * blob.size;

      // Wave movement effect
      final wavePhase = animationValue * 2 * math.pi * 0.5; // Wave speed
      final xOffset = size.width *
          0.5 *
          math.sin(blob.phase + wavePhase + blob.x * 2 * math.pi);
      final yOffset = size.height *
          0.5 *
          math.cos(blob.phase + wavePhase + blob.y * 2 * math.pi);

      final x = (blob.x * size.width + xOffset) % size.width;
      final y = (blob.y * size.height + yOffset) % size.height;

      // Draw shadow
      final shadowBlobPaint = Paint()
        ..color = shadowColor
        ..style = PaintingStyle.fill
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, pulse * size.width * 0.1);

      canvas.drawCircle(Offset(x + shadowOffset.dx, y + shadowOffset.dy),
          pulse * size.width, shadowBlobPaint);

      // Draw the actual blob
      final blobPaint = Paint()
        ..color = blob.color
        ..style = PaintingStyle.fill
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, pulse * size.width * 0.1);

      canvas.drawCircle(Offset(x, y), pulse * size.width, blobPaint);
    }

    // Soundwave effect
    final wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.blueAccent.withOpacity(0.5),
          Colors.purpleAccent.withOpacity(0.3),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    // Create soundwave effect with peaks
    for (double i = 0; i < size.width; i += 5) {
      double amplitude = 20 *
          math.sin(animationValue * 2 * math.pi * 2); // Dynamic peak height
      double y = size.height * 0.5 +
          amplitude *
              math.sin((i / size.width * 4 * math.pi) +
                  animationValue * 2 * math.pi);
      path.lineTo(i, y);
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(LightModeBackgroundPainter oldDelegate) => true;
}

class Blob {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double phase;

  Blob({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.phase,
  });
}
