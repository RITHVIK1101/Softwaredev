import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'screens/teacher_screen.dart';
import 'screens/student_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _schoolCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradeController = TextEditingController();
  String _role = 'student'; // Default role
  final AuthService _authService = AuthService();

  void _signup() async {
    final result = await _authService.register(
      _emailController.text,
      _passwordController.text,
      _role,
      _schoolCodeController.text,
      _firstNameController.text,
      _lastNameController.text,
      _gradeController.text,
    );
    if (result != null) {
      print('Signup successful, token: ${result['token']}');
      final args = {
        'token': result['token']!,
        'school': result['school']!,
        'firstName': result['firstName']!,
        'lastName': result['lastName']!,
        'userId': result['userId'] ?? '', // Ensure userId is non-nullable
      };
      if (result['role'] == 'teacher') {
        Navigator.pushNamed(context, '/teacher', arguments: args);
      } else if (result['role'] == 'student') {
        Navigator.pushNamed(context, '/student', arguments: args);
      }
    } else {
      print('Signup failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              TextField(
                controller: _schoolCodeController,
                decoration: InputDecoration(labelText: 'School Code'),
              ),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _gradeController,
                decoration: InputDecoration(labelText: 'Grade'),
              ),
              DropdownButton<String>(
                value: _role,
                onChanged: (String? newValue) {
                  setState(() {
                    _role = newValue!;
                  });
                },
                items: <String>['student', 'teacher']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
