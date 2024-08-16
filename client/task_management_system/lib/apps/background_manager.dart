import 'package:flutter/material.dart';
import 'package:task_management_system/apps/animated_flowing_background.dart';
import 'package:task_management_system/apps/animated_monkey_mode.dart';
import '../networking/personal_config_manager.dart';

class BackgroundManager {
  final PersonalConfigManager personalConfigManager = PersonalConfigManager();
  late Widget _background;

  BackgroundManager() {
    updateBackground();
  }

  void updateBackground() {
    if (personalConfigManager.getMonkey() == true) {
      _background = MonkeyModeBackground();
    } else if (personalConfigManager.getAnimated() == true) {
      _background = AnimatedBackground(
        isDarkMode: personalConfigManager.getDarkModeConfig(),
      );
    } else {
      _background = nonAnimatedBackground;
    }
  }

  Widget get nonAnimatedBackground {
    print(personalConfigManager.getDarkModeConfig());
    return CustomPaint(
      painter: _BackgroundPainter(
        isDarkMode: personalConfigManager.getDarkModeConfig(),
      ),
      child: Container(), // Ensures the painter fills the entire space
    );
  }

  Widget get background => _background;

  bool get darkMode => personalConfigManager.getDarkModeConfig();

  bool get animated => personalConfigManager.getAnimated();

  bool get monkeyMode => personalConfigManager.getMonkey();
}

class _BackgroundPainter extends CustomPainter {
  final bool isDarkMode;

  _BackgroundPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint backgroundPaint = Paint();

    if (isDarkMode) {
      // Dark Mode Shader
      backgroundPaint.shader = LinearGradient(
        colors: [Colors.black, Colors.deepPurple[900]!],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ).createShader(rect);
    } else {
      // Light Mode Shader
      backgroundPaint.shader = LinearGradient(
        colors: [
          Colors.blue[100]!,
          Colors.blue[300]!,
          Colors.purple[100]!,
          Colors.purple[300]!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    }

    // Draw the rectangle with the shader
    canvas.drawRect(rect, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
