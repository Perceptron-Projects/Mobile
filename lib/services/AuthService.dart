import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String apiUrl =
      'https://ld60zjeyel.execute-api.us-east-1.amazonaws.com/api/users/login';

  Future<String?> login(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        await const FlutterSecureStorage()
            .write(key: 'jwt_token', value: data['token']);
        return data['token'];
      } else {
        print('Registration failed. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Registration failed. Exception: $e');
      return null;
    }
  }

  Future<String?> getStoredToken() async {
    String? storedToken =
        await const FlutterSecureStorage().read(key: 'jwt_token');
    return storedToken;
  }
}
