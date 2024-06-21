import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ams/api/ApiClient.dart';

final workFromHomeProvider = StateNotifierProvider<WorkFromHomeNotifier, List<dynamic>>((ref) {
  return WorkFromHomeNotifier();
});

class WorkFromHomeNotifier extends StateNotifier<List<dynamic>> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  WorkFromHomeNotifier() : super([]);

  Future<void> fetchRequests() async {
    String? companyId = await _secureStorage.read(key: 'companyId');
    if (companyId == null) throw Exception("Company ID is not available");
    try {
      var response = await http.get(
          Uri.parse('${ApiClient.baseUrl}/api/users/attendance/request/$companyId'),
          headers: {'Content-Type': 'application/json'}
      );
      if (response.statusCode == 200) {
        state = json.decode(response.body);
      } else {
        state = [];
        throw Exception('Failed to load WFH requests: ${response.statusCode}');
      }
    } catch (e) {
      state = [];
      throw Exception('Error fetching requests: $e');
    }
  }

  Future<void> updateAttendanceStatus(String attendanceId, String status) async {
    String? token = await _secureStorage.read(key: 'token');
    if (token == null) throw Exception("Token not available");
    try {
      var response = await http.put(
          Uri.parse('${ApiClient.baseUrl}/api/users/employees/attendance/$attendanceId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({'whf': status})
      );
      if (response.statusCode == 200) {
        await fetchRequests(); // Refresh the list of requests
      } else {
        throw Exception('Failed to update request: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating request: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWorkFromHomeRequestsByDateRange(DateTime startDate, DateTime endDate) async {
    String? employeeId = await _secureStorage.read(key: 'userId');
    String? companyId = await _secureStorage.read(key: 'companyId');
    String? token = await _secureStorage.read(key: 'token');

    if (employeeId == null || companyId == null || token == null) {
      throw Exception('Employee ID, company ID, or token not found');
    }

    final response = await http.get(
      Uri.parse(
        '${ApiClient.baseUrl}/api/users/attendance/work-from-home/getByDateRange?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}&employeeId=$employeeId&companyId=$companyId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch work from home requests');
    }

    final data = json.decode(response.body);

    if (data['workFromHomeRequests'] == null) {
      throw Exception('No work from home requests found');
    }

    List<Map<String, dynamic>> workFromHomeRequests = List<Map<String, dynamic>>.from(data['workFromHomeRequests']);

    // Sort the work from home requests by date
    workFromHomeRequests.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });

    return workFromHomeRequests;
  }

}
