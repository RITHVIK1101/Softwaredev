import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  final String token;
  final String school;

  StudentScreen({required this.token, required this.school});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard'),
      ),
      body: Center(
        child: Text('Welcome to your $school dashboard'),
      ),
    );
  }
}
