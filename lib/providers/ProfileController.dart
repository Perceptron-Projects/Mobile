import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ams/api/ApiClient.dart';

final profileControllerProvider = Provider((ref) => ProfileController());

class ProfileController {


  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> getProfile() async {
    String? userId = await storage.read(key: 'userId');
    String? token = await storage.read(key: 'token');

    if (userId == null || token == null) {
      throw Exception('User ID or token not found');
    }

    final response = await http.get(
      Uri.parse(
        '${ApiClient.baseUrl}/api/users/$userId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch profile');
    }

    return json.decode(response.body);
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    String? userId = await storage.read(key: 'userId');
    String? token = await storage.read(key: 'token');

    if (userId == null || token == null) {
      throw Exception('User ID or token not found');
    }

    final response = await http.put(
      Uri.parse('${ApiClient.baseUrl}/api/users/employee/edit-profile/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profileData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }

    return;
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'userId');
    await storage.delete(key: 'companyId');
  }
}
