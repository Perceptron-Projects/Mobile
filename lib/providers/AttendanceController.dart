import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final attendanceControllerProvider = Provider((ref) => AttendanceController());

class AttendanceController {
  final storage = FlutterSecureStorage();

  Future<void> markAttendance(bool isCheckedIn, bool isCheckedOut) async {
    String? employeeId = await storage.read(key: 'userId');
    String? companyId = await storage.read(key: 'companyId');
    String? token = await storage.read(key: 'token');

    if (employeeId == null || companyId == null || token == null) {
      throw Exception('Employee ID, company ID, or token not found');
    }

    final response = await http.post(
      Uri.parse(
        'https://bnmpm8x1s8.execute-api.us-east-1.amazonaws.com/api/users/attendance/mark',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'employeeId': employeeId,
        'companyId': companyId,
        'time': DateTime.now().toIso8601String(),
        'isCheckedIn': isCheckedIn,
        'isCheckedOut': isCheckedOut,
        'isWorkFromHome': false,
      }),
    );

    if (response.statusCode != 200) {
      final responseData = json.decode(response.body);
      if (responseData['error'] == 'You are already checked in' || responseData['error'] == 'You are already checked out') {
        throw Exception(responseData['error']);
      } else {
        throw Exception('Failed to mark attendance');
      }
    }
  }

  Future<Map<String, bool>> getAttendanceStatus() async {
    String? employeeId = await storage.read(key: 'userId');
    String? companyId = await storage.read(key: 'companyId');
    String? token = await storage.read(key: 'token');

    if (employeeId == null || companyId == null || token == null) {
      throw Exception('Employee ID, company ID, or token not found');
    }

    final response = await http.get(
      Uri.parse(
        'https://bnmpm8x1s8.execute-api.us-east-1.amazonaws.com/api/users/attendance/status?employeeId=$employeeId&companyId=$companyId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch attendance status');
    }

    final data = json.decode(response.body);
    return {
      'isCheckedIn': data['isCheckedIn'],
      'isCheckedOut': data['isCheckedOut'],
    };
  }

  Future<List<Map<String, dynamic>>> getAttendanceByDateRange(DateTime startDate, DateTime endDate) async {
    String? employeeId = await storage.read(key: 'userId');
    String? companyId = await storage.read(key: 'companyId');
    String? token = await storage.read(key: 'token');

    if (employeeId == null || companyId == null || token == null) {
      throw Exception('Employee ID, company ID, or token not found');
    }

    final response = await http.get(
      Uri.parse(
        'https://bnmpm8x1s8.execute-api.us-east-1.amazonaws.com/api/users/attendance/getByDateRange?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}&employeeId=$employeeId&companyId=$companyId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch attendance records');
    }

    final data = json.decode(response.body);

    List<Map<String, dynamic>> attendanceRecords = List<Map<String, dynamic>>.from(data['attendanceRecords']);

    // Sort the attendance records by date
    attendanceRecords.sort((a, b) {
      DateTime dateA = DateTime.parse(a['time']);
      DateTime dateB = DateTime.parse(b['time']);
      return dateB.compareTo(dateA);
    });

    return attendanceRecords;
  }
}
