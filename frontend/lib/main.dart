import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'screens/teacher_screen.dart';
import 'screens/student_screen.dart';
import 'screens/assignments_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/teacher': (context) => TeacherScreen(
          token: ModalRoute.of(context)!.settings.arguments as String,
          school: ModalRoute.of(context)!.settings.arguments as String,
          firstName: ModalRoute.of(context)!.settings.arguments as String,
          lastName: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/student': (context) => StudentScreen(
          token: ModalRoute.of(context)!.settings.arguments as String,
          school: ModalRoute.of(context)!.settings.arguments as String,
          firstName: ModalRoute.of(context)!.settings.arguments as String,
          lastName: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/assignments': (context) => AssignmentsScreen(),
      },
    );
  }
}