import 'package:flutter/material.dart';
import 'package:task_management_system/networking/standards/base.dart';
import 'package:task_management_system/networking/standards/utility.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/apps/task_list_page.dart';

class LoginPage extends StatelessWidget {
  final PageController pageController;

  LoginPage({required this.pageController});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final tms = TaskManagementSystem();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    child:
                        Text('Don\'t have an account? Swipe left to Register'),
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
    );
  }

  Future<void> _login(BuildContext context) async {
    bool success = await tms.loginUser(
      Verification_Type(
        Username_Type.fromString(_usernameController.text),
        createHash(_passwordController.text),
      ),
    );
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListPage(tms)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }
}
