import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  final String token;
  final String school;
  final String firstName;
  final String lastName;
  final String userId;

  StudentScreen({
    required this.token,
    required this.school,
    required this.firstName,
    required this.lastName,
    required this.userId,
  });

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.school),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome ${widget.firstName} ${widget.lastName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Assignments'),
              onTap: () {
                Navigator.pushNamed(context, '/assignments');
              },
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('Stress Management'),
              onTap: () {
                // Add navigation to the stress management screen
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Classes'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/student/classes',
                  arguments: {
                    'token': widget.token,
                    'userId': widget.userId,
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Add navigation to the settings screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
