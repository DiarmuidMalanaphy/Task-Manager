import 'package:flutter/material.dart';
import 'package:task_management_system/networking/standards/base.dart';
import 'package:task_management_system/networking/standards/utility.dart';
import 'networking/task_management_system.dart';
import 'package:task_management_system/apps/TaskListPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final tms = TaskManagementSystem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: _login,
                ),
                ElevatedButton(
                  child: Text('Register'),
                  onPressed: _register,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    bool success = await tms.loginUser(
      Verification(Username.fromString(_usernameController.text),
          createHash(_passwordController.text)),
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

  Future<void> _register() async {
    bool success = await tms.registerUser(
      _usernameController.text,
      _passwordController.text,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed')),
      );
    }
  }
}
