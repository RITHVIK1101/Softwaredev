import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
      ),
      body: Center(
        child: Text('List of assignments will be displayed here.'),
      ),
    );
  }
}
