import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';

final authControllerProvider = Provider((ref) => AuthController());

class AuthController {
  static const String baseUrl =
      'https://ld60zjeyel.execute-api.us-east-1.amazonaws.com';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'role': 'employee',
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        // Save token securely
        await _secureStorage.write(key: 'token', value: token);

        final String userId = responseData['userId'];

        // Perform authorized request after successful sign-in
        final userData = await authorizedRequest('GET', '/api/users/$userId');
        return userData;
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<Map<String, dynamic>> authorizedRequest(
      String method, String endPoint) async {
    final token = await getAuthToken();

    if (token == null) {
      throw Exception("Token not available.");
    }

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final Uri uri = Uri.parse('$baseUrl$endPoint');
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to make authorized request: ${response.statusCode}');
    }
  }

  Future<bool> isAuthenticated() async {
    // Check if token exists in secure storage
    final token = await _secureStorage.read(key: 'token');
    return token != null;
  }

  Future<void> signOut() async {
    // Remove token from secure storage
    await _secureStorage.delete(key: 'token');
  }

  Future<String?> getAuthToken() async {
    // Retrieve token from secure storage
    return _secureStorage.read(key: 'token');
  }
}
