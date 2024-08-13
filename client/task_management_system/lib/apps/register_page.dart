import 'package:flutter/material.dart';
import 'package:task_management_system/apps/IPsettings.dart';
import 'package:task_management_system/networking/auth.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/apps/task_list_page.dart';

class RegisterPage extends StatelessWidget {
  final PageController pageController;

  RegisterPage({required this.pageController});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
                  title: Text('Register'),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => pageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildTextField(_usernameController, 'Username'),
                        SizedBox(height: 10),
                        _buildTextField(_passwordController, 'Password',
                            isPassword: true),
                        SizedBox(height: 10),
                        _buildTextField(
                            _confirmPasswordController, 'Confirm Password',
                            isPassword: true),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                          ),
                          child:
                              Text('Register', style: TextStyle(fontSize: 18)),
                          onPressed: () => _register(context),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          child: Text(
                              'Already have an account? Swipe right to Login'),
                          onPressed: () {
                            pageController.animateToPage(
                              0,
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

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isPassword,
    );
  }

  Future<void> _register(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    ReturnError err;
    err = await tms.registerUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (err.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListPage(tms)),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.message)),
      );
    }
  }
}
