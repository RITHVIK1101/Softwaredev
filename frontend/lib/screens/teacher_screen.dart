import 'package:flutter/material.dart';

class TeacherScreen extends StatelessWidget {
  final String token;
  final String school;
  final String firstName;
  final String lastName;

  TeacherScreen({
    required this.token,
    required this.school,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(school),
        automaticallyImplyLeading: false, // This removes the back arrow
      ),
      body: Center(
        child: Text('Welcome $firstName $lastName'),
      ),
    );
  }
}
