import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherScreen extends StatefulWidget {
  final String token;
  final String school;
  final String firstName;
  final String lastName;

  TeacherScreen({required this.token, required this.school, required this.firstName, required this.lastName});

  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<Map<String, dynamic>> classes = [];
  List<String> selectedStudents = [];

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  void _fetchClasses() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/classes?teacher=${widget.firstName} ${widget.lastName}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response Data: $responseData');  // Log the response data
        if (responseData != null) {
          setState(() {
            classes = List<Map<String, dynamic>>.from(responseData);
          });
        } else {
          print('Error: Response data is null');
        }
      } else {
        print('Failed to fetch classes: ${response.body}');
      }
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  void _addClass(String className, String subject, String period, String design) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/classes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: json.encode({
          'className': className,
          'subject': subject,
          'period': period,
          'design': design,
          'teacher': widget.firstName + ' ' + widget.lastName,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('Added Class: $responseData');  // Log the added class data
        setState(() {
          classes.add({
            'className': className,
            'subject': subject,
            'period': period,
            'design': design,
          });
        });
      } else {
        print('Failed to add class: ${response.body}');
      }
    } catch (error) {
      print('Error adding class: $error');
    }
  }

  void _showAddClassDialog() {
    String className = '';
    String subject = 'Subject';
    String period = 'Period';
    String design = 'Design';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Class'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Class Name'),
                    onChanged: (value) {
                      className = value;
                    },
                  ),
                  DropdownButton<String>(
                    value: subject,
                    hint: Text('Select Subject'),
                    items: <String>[
                      'Subject',
                      'English',
                      'Science',
                      'Math',
                      'Arts',
                      'Sports',
                      'PE',
                      'Engineering',
                      'Social Science',
                      'Language'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        subject = newValue!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: period,
                    hint: Text('Select Period'),
                    items: <String>[
                      'Period', 'Before-school', '1', '2', '3', '4', '5', '6', '7', 'Other', 'After-school'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        period = newValue!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: design,
                    hint: Text('Select Design'),
                    items: <String>['Design', 'Design1', 'Design2', 'Design3', 'Design4']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        design = newValue!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addClass(className, subject, period, design);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentsDialog(String className) {
    TextEditingController searchController = TextEditingController();
    FocusNode searchFocusNode = FocusNode();
    List<Map<String, dynamic>> allStudents = [];
    List<Map<String, dynamic>> searchResults = [];
    List<String> selectedStudents = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void fetchStudents() async {
              try {
                final response = await http.get(
                  Uri.parse('http://localhost:3000/students?school=${widget.school}'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}',
                  },
                );

                if (response.statusCode == 200) {
                  allStudents = List<Map<String, dynamic>>.from(json.decode(response.body));
                  searchResults = allStudents;

                  if (searchController.text.isNotEmpty) {
                    searchResults = allStudents
                        .where((student) =>
                            '${student['firstName']} ${student['lastName']}'.toLowerCase().contains(searchController.text.toLowerCase()))
                        .toList();
                  }

                  setState(() {});
                } else {
                  print('Failed to fetch students: ${response.body}');
                }
              } catch (error) {
                print('Error fetching students: $error');
              }
            }

            void addStudentsToClass() async {
              if (selectedStudents.isEmpty) {
                // No students selected, show a message or handle accordingly
                print('No students selected');
                return;
              }

              print('Selected students: $selectedStudents');
              try {
                final response = await http.post(
                  Uri.parse('http://localhost:3000/classes/addStudents'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${widget.token}',
                  },
                  body: json.encode({
                    'className': className,
                    'students': selectedStudents.map((id) => id.toString()).toList(),
                  }),
                );

                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedStudents.clear();
                  });
                } else {
                  print('Failed to add students to class: ${response.body}');
                }
              } catch (error) {
                print('Error adding students to class: $error');
              }
            }

            searchFocusNode.addListener(() {
              if (searchFocusNode.hasFocus) {
                fetchStudents();
              }
            });

            return AlertDialog(
              title: const Text('Add Students'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Search Students',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: fetchStudents,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  searchResults.isEmpty
                      ? Text('No students found')
                      : Container(
                          width: double.maxFinite,
                          height: 300,
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final student = searchResults[index];
                              return CheckboxListTile(
                                title: Text('${student['firstName']} ${student['lastName']}'),
                                subtitle: Text('Grade: ${student['grade']}'),
                                value: selectedStudents.contains(student['_id']),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedStudents.add(student['_id']);
                                    } else {
                                      selectedStudents.remove(student['_id']);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: addStudentsToClass,
                  child: const Text('Add Students'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getDesignColor(String design) {
    switch (design) {
      case 'Design1':
        return Colors.blue;
      case 'Design2':
        return Colors.green;
      case 'Design3':
        return Colors.red;
      case 'Design4':
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.school),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showAddClassDialog,
              child: Text('Add Class'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: _getDesignColor(classes[index]['design']),
                    child: ListTile(
                      title: Text(classes[index]['className']),
                      subtitle: Text('${classes[index]['subject']} - Period ${classes[index]['period']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.person_add),
                            onPressed: () {
                              _showAddStudentsDialog(classes[index]['className']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.assignment),
                            onPressed: () {
                              // Navigate to assignment screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssignmentsScreen(className: classes[index]['className']),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentsScreen extends StatelessWidget {
  final String className;

  AssignmentsScreen({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments for $className'),
      ),
      body: Center(
        child: Text('Assignments will be shown here'),
      ),
    );
  }
}
