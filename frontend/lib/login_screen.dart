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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login_background.png'), // Add your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
      
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Semi-transparent background for the box
              borderRadius: BorderRadius.circular(40.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.5, // Box width relative to screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    
                    
                    
                    
                    ),
                  obscureText: true,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
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
        ),
      ),
    );
  }
  }

