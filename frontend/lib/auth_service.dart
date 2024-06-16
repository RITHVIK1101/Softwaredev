import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:3000'; // Adjust this if necessary

Future<String?> register(String email, String password, String role, String schoolCode) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'role': role, 'schoolCode': schoolCode}),
    );
    if (response.statusCode == 201) {
      return 'User registered';
    } else {
      print('Failed to register: ${response.body}');
      return 'Registration failed';
    }
  } catch (e) {
    print('Error during registration: $e');
    return 'Registration failed';
  }
}

Future<Map<String, String>?> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final String? token = jsonResponse['token'];
      final String? role = jsonResponse['role'];
      final String? school = jsonResponse['school'];

      if (token != null && role != null && school != null) {
        return {'token': token, 'role': role, 'school': school};
      } else {
        print('Login failed: Token, role, or school is null');
        return null;
      }
    } else {
      print('Failed to login: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error during login: $e');
    return null;
  }
}


  Future<String?> getProtectedData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/protected'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['message'];
      } else {
        print('Failed to fetch protected data: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during fetching protected data: $e');
      return null;
    }
  }
}
