import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ams/api/ApiClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HolidayController {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<String?> getAuthToken() async {
    // Retrieve token from secure storage
    return _secureStorage.read(key: 'token');
  }

  Future<void> createHoliday(Map<String, dynamic> holidayData) async {
    final token = await getAuthToken();
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/api/calendar/holidays'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(holidayData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create holiday');
    }
  }

  Future<List<Map<String, dynamic>>> getHolidays() async {
    final token = await getAuthToken();
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/calendar/holidays'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch holidays');
    }

    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  Future<void> editHoliday(String day, Map<String, dynamic> holidayData) async {
    final token = await getAuthToken();

    final response = await http.put(
      Uri.parse('${ApiClient.baseUrl}/api/calendar/holidays/$day'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(holidayData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update holiday');
    }
  }

  Future<void> deleteHoliday(String day) async {
    final token = await getAuthToken();

    final response = await http.delete(
      Uri.parse('${ApiClient.baseUrl}/api/calendar/holidays/$day'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete holiday');
    }
  }


}
