import 'package:flutter/material.dart';
import 'package:task_management_system/apps/background_manager.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import '../networking/auth.dart';
import '../apps/auth_page.dart';
import 'package:task_management_system/networking/standards/verification.dart';
import 'task_list_page.dart';
import 'IPsettings.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late Auth _auth;
  late TaskManagementSystem _tms;
  bool _showButtons = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final BackgroundManager _backgroundManager = BackgroundManager();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _auth = Auth();
      _tms = TaskManagementSystem(_auth);
      await _tms.initializeIP();
      _checkAuthStatus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    if (_auth.hasVerificationToken() && _auth.isTokenValid()) {
      await _loginWithToken();
    } else if (_auth.hasInitialVerification()) {
      await _loginWithVerification();
    } else {
      _showLoginOptions();
    }
  }

  Future<void> _loginWithToken() async {
    if (!mounted) return;
    try {
      Verification_Token_Type? token = _auth.getVerificationToken();
      if (token != null) {
        ReturnError err = await _tms.verifyToken();
        if (err.success) {
          _navigateToTaskList();
        } else {
          _loginWithVerification();
        }
      } else {
        await _loginWithVerification();
      }
    } catch (e) {
      _showErrorSnackBar(context, 'An unexpected error occurred.');
      await _loginWithVerification();
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior
            .floating, // Makes the SnackBar float over the content
        duration: const Duration(seconds: 3), // Adjust the duration
      ),
    );
  }

  Future<void> _loginWithVerification() async {
    if (!mounted) return;
    try {
      Initialisation_Verification_Type? verification =
          _auth.getInitialVerification();
      if (verification != null) {
        ReturnError err = await _tms.getAuthToken(verification);
        if (err.success) {
          _navigateToTaskList();
        } else {
          _showErrorSnackBar(context, err.message);
          _showLoginOptions();
        }
      } else {
        _showLoginOptions();
      }
    } catch (e) {
      _showLoginOptions();
    }
  }

  void _showLoginOptions() {
    _animationController.stop();
    if (mounted) {
      setState(() {
        _showButtons = true;
      });
    }
  }

  void _navigateToTaskList() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TaskListPage(_tms, _backgroundManager)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundManager.background,
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -_animation.value),
                        child: child,
                      );
                    },
                    child: Text(
                      "Diarmuid's GTD App",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  if (_showButtons) ...[
                    _buildButton('Login', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthPage(
                                initialPage: 0,
                                backgroundManager: _backgroundManager)),
                      );
                    }),
                    SizedBox(height: 20),
                    _buildButton('Register', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthPage(
                                  initialPage: 1,
                                  backgroundManager: _backgroundManager,
                                )),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
          if (_showButtons)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IPSettings(
                              backgroundManager: _backgroundManager,
                            )),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        elevation: 5,
      ),
      child: Text(text, style: TextStyle(fontSize: 18)),
      onPressed: onPressed,
    );
  }
}
