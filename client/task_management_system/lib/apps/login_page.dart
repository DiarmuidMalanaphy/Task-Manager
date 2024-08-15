import 'package:flutter/material.dart';
import 'package:task_management_system/networking/auth.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/standards/username.dart';
import 'package:task_management_system/networking/standards/hash.dart';
import 'package:task_management_system/networking/standards/password.dart';
import 'package:task_management_system/networking/standards/verification.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/apps/task_list_page.dart';
import 'package:task_management_system/apps/background_manager.dart';

class LoginPage extends StatelessWidget {
  final PageController pageController;
  final BackgroundManager backgroundManager;

  LoginPage({required this.pageController, required this.backgroundManager});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final tms = TaskManagementSystem(Auth());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backgroundManager.background,
          Container(
            //  decoration: BoxDecoration(
//              gradient: LinearGradient(
//                begin: Alignment.topLeft,
//                end: Alignment.bottomRight,
//               colors: [
//                  Colors.blue[100]!,
//                  Colors.blue[300]!,
//                  Colors.purple[100]!,
//                  Colors.purple[300]!,
//                ],
//                stops: [0.0, 0.4, 0.7, 1.0],
//              ),
            //),
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    'Login',
                    style: TextStyle(
                      color:
                          Colors.blue[100], // This sets the color of the text
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child: Text('Login', style: TextStyle(fontSize: 18)),
                          onPressed: () => _login(context),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          child: Text(
                            'Don\'t have an account? Swipe left to Register',
                            style: TextStyle(
                              color: Colors
                                  .blue[100], // This sets the color of the text
                            ),
                          ),
                          onPressed: () {
                            pageController.animateToPage(
                              1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    Initialisation_Verification_Type verification =
        Initialisation_Verification_Type(
      Username_Type.fromString(_usernameController.text),
      Hash_Type(Password.fromString(_passwordController.text)),
    );
    ReturnError err;
    err = await tms.getAuthToken(
      verification,
    );
    if (err.success) {
      tms.setVerification(verification);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TaskListPage(tms, backgroundManager)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.message)),
      );
    }
  }
}
