import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'screens/teacher_screen.dart';
import 'screens/student_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    final result = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (result != null) {
      print('Login successful, token: ${result['token']}');
      if (result['role'] == 'teacher') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherScreen(
              token: result['token']!,
              school: result['school']!,
              firstName: result['firstName']!,
              lastName: result['lastName']!,
            ),
          ),
        );
      } else if (result['role'] == 'student') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentScreen(
              token: result['token']!,
              school: result['school']!,
              firstName: result['firstName']!,
              lastName: result['lastName']!,
            ),
          ),
        );
      }
    } else {
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
