import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';
import 'package:ams/api/ApiClient.dart';
import 'package:http/http.dart' as http;


final authControllerProvider = Provider((ref) => AuthController());

class AuthController {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/api/users/login'), // Use ApiClient's baseUrl
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'role': 'employee',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        final String userId = responseData['userId'];
        final String companyId = responseData['companyId'];
        final List<String> roles = List<String>.from(responseData['role']);
        final int expiresIn = responseData['expiresIn'];

        // Save each value securely
        await _secureStorage.write(key: 'token', value: token);
        await _secureStorage.write(key: 'userId', value: userId);
        await _secureStorage.write(key: 'companyId', value: companyId);
        await _secureStorage.write(key: 'roles', value: jsonEncode(roles));
        await _secureStorage.write(key: 'expiresIn', value: expiresIn.toString());

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

  Future<Map<String, dynamic>> authorizedRequest(String method, String endPoint) async {
    final token = await getAuthToken();

    if (token == null) {
      throw Exception("Token not available.");
    }

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final Uri uri = Uri.parse('${ApiClient.baseUrl}$endPoint');
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to make authorized request: ${response.statusCode}');
    }
  }

  Future<List<String>> getUserRoles() async {
    String? userId = await _secureStorage.read(key: 'userId');
    String? token = await _secureStorage.read(key: 'token');

    if (userId == null || token == null) {
      throw Exception('User ID or token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user roles');
    }

    final data = json.decode(response.body);
    List<String> roles = List<String>.from(data['role']);
    return roles;
  }

  Future<bool> isAuthenticated() async {
    // Check if token exists in secure storage
    final token = await _secureStorage.read(key: 'token');
    return token != null;
  }

  Future<void> signOut() async {
    // Remove all stored values from secure storage
    await _secureStorage.deleteAll();
  }

  Future<String?> getAuthToken() async {
    // Retrieve token from secure storage
    return _secureStorage.read(key: 'token');
  }

  Future<String?> getUserId() async {
    // Retrieve userId from secure storage
    return _secureStorage.read(key: 'userId');
  }

  Future<String?> getFirstName() async {
    // Retrieve companyId from secure storage
    return _secureStorage.read(key: 'firstName');
  }

  Future<String?> getCompanyId() async {
    // Retrieve companyId from secure storage
    return _secureStorage.read(key: 'companyId');
  }

  Future<List<String>?> getRoles() async {
    // Retrieve roles from secure storage
    String? rolesString = await _secureStorage.read(key: 'roles');
    if (rolesString != null) {
      return List<String>.from(jsonDecode(rolesString));
    }
    return null;
  }

  Future<int?> getExpiresIn() async {
    // Retrieve expiresIn from secure storage
    String? expiresInString = await _secureStorage.read(key: 'expiresIn');
    if (expiresInString != null) {
      return int.tryParse(expiresInString);
    }
    return null;
  }
}