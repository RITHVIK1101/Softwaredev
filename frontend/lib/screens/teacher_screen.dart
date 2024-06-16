import 'package:flutter/material.dart';

class TeacherScreen extends StatelessWidget {
  final String token;
  final String school;

  TeacherScreen({required this.token, required this.school});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to your $school dashboard'),
      ),
    );
  }
}
