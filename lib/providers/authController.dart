import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'dart:convert';

final authControllerProvider = Provider((ref) => AuthController());

class AuthController {
  static const String baseUrl = 'https://ld60zjeyel.execute-api.us-east-1.amazonaws.com'; // Update with your backend base URL

  Future<Map<String, dynamic>> signIn(String email, String password) async {

    await Future.delayed(const Duration(seconds: 2));

    try {

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}
