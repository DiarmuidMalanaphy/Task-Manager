import 'package:flutter/material.dart';
import 'package:task_management_system/apps/background_manager.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatelessWidget {
  final int initialPage;
  final BackgroundManager backgroundManager;

  AuthPage({required this.initialPage, required this.backgroundManager});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController =
        PageController(initialPage: initialPage);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          LoginPage(
              pageController: _pageController,
              backgroundManager: backgroundManager),
          RegisterPage(
              pageController: _pageController,
              backgroundManager: backgroundManager),
        ],
      ),
    );
  }
}
