import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatelessWidget {
  final int initialPage;

  AuthPage({required this.initialPage});

  @override
  Widget build(BuildContext context) {
    final PageController _pageController =
        PageController(initialPage: initialPage);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          LoginPage(pageController: _pageController),
          RegisterPage(pageController: _pageController),
        ],
      ),
    );
  }
}
