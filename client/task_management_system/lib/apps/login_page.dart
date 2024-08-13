import 'package:flutter/material.dart';
import 'package:task_management_system/apps/IPsettings.dart';
import 'package:task_management_system/networking/auth.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/standards/username.dart';
import 'package:task_management_system/networking/standards/hash.dart';
import 'package:task_management_system/networking/standards/password.dart';
import 'package:task_management_system/networking/standards/verification.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/apps/task_list_page.dart';

class LoginPage extends StatelessWidget {
  final PageController pageController;

  LoginPage({required this.pageController});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final tms = TaskManagementSystem(Auth());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[100]!, Colors.blue[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text('Login'),
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
                              'Don\'t have an account? Swipe left to Register'),
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
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.black54),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IPSettings()),
                );
              },
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
        MaterialPageRoute(builder: (context) => TaskListPage(tms)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.message)),
      );
    }
  }
}
