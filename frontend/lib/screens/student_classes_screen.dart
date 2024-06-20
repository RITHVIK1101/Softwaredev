import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentClassesScreen extends StatefulWidget {
  final String token;
  final String userId;

  StudentClassesScreen({required this.token, required this.userId});

  @override
  _StudentClassesScreenState createState() => _StudentClassesScreenState();
}

class _StudentClassesScreenState extends State<StudentClassesScreen> {
  List<Map<String, dynamic>> classes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/students/${widget.userId}/classes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          classes = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
        print('Classes fetched: $classes');
      } else {
        print('Failed to fetch classes: ${response.body}');
        setState(() {
          errorMessage = 'Failed to fetch classes: ${response.body}';
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching classes: $error');
      setState(() {
        errorMessage = 'Error fetching classes: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Classes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final classData = classes[index];
                    return ListTile(
                      title: Text(classData['className']),
                      subtitle: Text('${classData['subject']} - Period ${classData['period']}'),
                    );
                  },
                ),
    );
  }
}
