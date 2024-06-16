import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';  // Import the SignupScreen
import 'screens/teacher_screen.dart';
import 'screens/student_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Disable the debug banner
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),  // Add the signup route
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/teacher') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return TeacherScreen(token: args['token']!, school: args['school']!);
            },
          );
        } else if (settings.name == '/student') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return StudentScreen(token: args['token']!, school: args['school']!);
            },
          );
        }
        return null;
      },
    );
  }
}
