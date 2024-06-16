import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'signup_screen.dart';  // Import the SignupScreen

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
    if (result != null && result['token'] != null && result['role'] != null && result['school'] != null) {
      print('Login successful, token: ${result['token']}, role: ${result['role']}, school: ${result['school']}');
      if (result['role'] == 'teacher') {
        Navigator.pushReplacementNamed(
          context,
          '/teacher',
          arguments: {'token': result['token']!, 'school': result['school']!},
        );
      } else if (result['role'] == 'student') {
        Navigator.pushReplacementNamed(
          context,
          '/student',
          arguments: {'token': result['token']!, 'school': result['school']!},
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
                Navigator.pushNamed(context, '/signup');  // Navigate to signup screen
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
