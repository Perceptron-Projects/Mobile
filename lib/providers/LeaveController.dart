import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ams/api/ApiClient.dart';
import 'package:intl/intl.dart';

final leaveControllerProvider = Provider((ref) => LeaveController());

class LeaveController {
  final storage = FlutterSecureStorage();

  Future<void> requestLeave(String leaveType, DateTime startDate, DateTime endDate, String reason) async {
    String? employeeId = await storage.read(key: 'userId');
    String? companyId = await storage.read(key: 'companyId');
    String? token = await storage.read(key: 'token');

    if (employeeId == null || companyId == null || token == null) {
      throw Exception('Employee ID, company ID, or token not found');
    }

    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/leave/request'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'employeeId': employeeId,
        'companyId': companyId,
        'leaveType': leaveType,
        'startDate': DateFormat('yyyy-MM-dd').format(startDate),
        'endDate': DateFormat('yyyy-MM-dd').format(endDate),
        'reason': reason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit leave request');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaveRequests(String employeeId) async {
    String? token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/leave/$employeeId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch leave requests');
    }

    final data = json.decode(response.body) as List;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> getPendingLeaveRequests(String companyId) async {
    String? token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/leave/request/pending/$companyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch pending leave requests');
    }

    final data = json.decode(response.body) as List;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<void> updateLeaveRequest(String leaveId, String status, String createdAt) async {
    String? token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/leave/request/response/$leaveId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'status': status,
        'createdAt': createdAt,
      }),
    );

    if (response.statusCode != 200) {
      print('Response: ${response.body}');
      throw Exception('Failed to update leave request');
    }
  }

  Future<Map<String, dynamic>> getLeaveCounts(String employeeId) async {
    String? token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/leave/approved/$employeeId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch leave counts');
    }

    final data = json.decode(response.body);
    return data as Map<String, dynamic>;
  }


}
