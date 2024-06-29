import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ams/api/ApiClient.dart';
import 'package:intl/intl.dart';

final attendanceControllerProvider = Provider((ref) => AttendanceController());

class AttendanceController {
  final storage = FlutterSecureStorage();

  Future<void> markAttendance(bool isCheckedIn, bool isCheckedOut, bool isWorkFromHome) async {
    String? employeeId = await storage.read(key: 'userId');
    String? companyId = await storage.read(key: 'companyId');
    String? token = await storage.read(key: 'token');

    if (employeeId == null || companyId == null || token == null) {
      throw Exception('Employee ID, company ID, or token not found');
    }

    print(employeeId);

    final response = await http.patch(
      Uri.parse(
        '${ApiClient.baseUrl}/api/users/attendance/mark',
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
        'isWorkFromHome': isWorkFromHome,
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
          '${ApiClient.baseUrl}/api/users/attendance/checkForTheDay/$employeeId',
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
        '${ApiClient.baseUrl}/api/users/attendance/getByDateRange?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}&employeeId=$employeeId&companyId=$companyId',
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

    if (data['attendanceRecords'] == null) {
      throw Exception('No attendance records found');
    }

    List<Map<String, dynamic>> attendanceRecords = List<Map<String, dynamic>>.from(data['attendanceRecords']);


    // Filter out any records where 'date' is null or not a string
    attendanceRecords = attendanceRecords.where((record) => record['date'] != null && record['date'] is String).toList();

    // Ensure all bool fields are non-null
    attendanceRecords = attendanceRecords.map((record) {
      record['isCheckedIn'] = record['isCheckedIn'] ?? false;
      record['isCheckedOut'] = record['isCheckedOut'] ?? false;
      record['isWorkFromHome'] = record['isWorkFromHome'] ?? false;
      return record;
    }).toList();


    // Sort the attendance records by date
    attendanceRecords.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA);
    });


    return attendanceRecords;
  }


  Future<void> sendWorkFromHomeRequest(DateTime date) async {
      String? employeeId = await storage.read(key: 'userId');
      String? companyId = await storage.read(key: 'companyId');
      String? token = await storage.read(key: 'token');

      final dateFormatter = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormatter.format(date);

      if (employeeId == null || companyId == null || token == null) {
        throw Exception('Employee ID, company ID, or token not found');
      }

      final response = await http.patch(
        Uri.parse(
          '${ApiClient.baseUrl}/api/users/attendance/work-from-home/request',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'employeeId': employeeId,
          'companyId': companyId,
          'date': formattedDate,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit work from home request');
      }
    }

    Future<String> getWorkFromHomeStatus(DateTime date) async {
      String? employeeId = await storage.read(key: 'userId');
      String? companyId = await storage.read(key: 'companyId');
      String? token = await storage.read(key: 'token');

      final dateFormatter = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormatter.format(date);

      if (employeeId == null || companyId == null || token == null) {
        throw Exception('Employee ID, company ID, or token not found');
      }

      final response = await http.get(
        Uri.parse(
          '${ApiClient.baseUrl}/api/users/attendance/work-from-home/status?employeeId=$employeeId&companyId=$companyId&date=$formattedDate',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch work from home status');
      }

      final data = json.decode(response.body);
      return data['status']??' ';
    }

  Future<List<Map<String, dynamic>>> getAllWorkFromHomeRequests() async {
    String? supervisorId = await storage.read(key: 'userId');
    String? token = await storage.read(key: 'token');

    if (supervisorId == null || token == null) {
      throw Exception('Supervisor ID or token not found');
    }

    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/attendance/work-from-home/all-requests'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch work from home requests');
    }

    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);  // Ensure the data is parsed correctly
  }

  Future<List<Map<String, dynamic>>> getWFHRequestsByDateRange(DateTime startDate, DateTime endDate) async {
    String? employeeId = await storage.read(key: 'userId');
    String? companyId = await storage.read(key: 'companyId');
    String? token = await storage.read(key: 'token');

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


  Future<void> updateWorkFromHomeStatus(

      String employeeId, String companyId, DateTime date, String status) async {
      String? supervisorId = await storage.read(key: 'userId');
      String? token = await storage.read(key: 'token');

    if (supervisorId == null || token == null) {
      throw Exception('Supervisor ID or token not found');
    }

    final dateFormatter = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormatter.format(date);

    final response = await http.patch(
      Uri.parse('${ApiClient.baseUrl}/api/users/attendance/work-from-home/update-status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'employeeId': employeeId,
        'companyId': companyId,
        'date': formattedDate,
        'status': status,
      }),
    );

    if (response.statusCode != 200) {
      print('Failed to update work from home request status: ${response.body}');
      throw Exception('Failed to update work from home request status');
    }

    print('Work from home request status updated successfully: ${response.body}');
  }



}
