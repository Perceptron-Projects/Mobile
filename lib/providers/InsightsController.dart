import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ams/api/ApiClient.dart';
import 'package:ams/providers/AuthController.dart';

class InsightsController {
  static const int definedWorkedHours = 9;
  static const int definedWorkedDays = 5;
  static const int plannedHours = definedWorkedHours*definedWorkedDays;

  Future<Map<String, dynamic>> fetchAttendanceData(DateTime startDate, DateTime endDate) async {
    final token = await AuthController().getAuthToken();
    String? employeeId = await AuthController().getUserId();
    final response = await http.get(
      Uri.parse(
          '${ApiClient.baseUrl}/api/users/employees/attendance/$employeeId/${DateFormat('yyyy-MM-dd').format(startDate)}/${DateFormat('yyyy-MM-dd').format(endDate)}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load attendance data');
    }
  }

  Future<List<dynamic>> fetchLeaveData() async {
    final token = await AuthController().getAuthToken();
    String? employeeId = await AuthController().getUserId();
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/leave/$employeeId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load leave data');
    }
  }

  Future<Map<String, dynamic>> fetchAttendanceDataForUser(DateTime startDate, DateTime endDate, String userId) async {
    final token = await AuthController().getAuthToken();
    final response = await http.get(
      Uri.parse('${ApiClient.baseUrl}/api/users/employees/attendance/$userId/${DateFormat('yyyy-MM-dd').format(startDate)}/${DateFormat('yyyy-MM-dd').format(endDate)}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load attendance data');
    }
  }

  Map<String, dynamic> processAttendanceData(Map<String, dynamic> attendanceData, List<dynamic> leaveData) {
    double totalWorkedHours = 0;
    double totalOvertimeHours = 0;
    double totalNegativeHours = 0;
    int workedDays = 0;

    Map<String, double> workedHours = {
      'mon': (attendanceData['mon'] ?? 0).toDouble(),
      'tue': (attendanceData['tue'] ?? 0).toDouble(),
      'wed': (attendanceData['wed'] ?? 0).toDouble(),
      'thu': (attendanceData['thu'] ?? 0).toDouble(),
      'fri': (attendanceData['fri'] ?? 0).toDouble(),
    };

    workedHours.forEach((day, hours) {
      if (hours > 0) {
        workedDays++;
        totalWorkedHours += hours;

        if (hours > definedWorkedHours) {
          totalOvertimeHours += (hours - definedWorkedHours);
        } else {
          totalNegativeHours += (definedWorkedHours - hours);
        }
      }
    });

    double averageActivity = (totalWorkedHours / (definedWorkedHours * definedWorkedDays)) * 100;

    // Rounding values to 2 decimal places
    totalWorkedHours = double.parse(totalWorkedHours.toStringAsFixed(2));
    totalOvertimeHours = double.parse(totalOvertimeHours.toStringAsFixed(2));
    totalNegativeHours = double.parse(totalNegativeHours.toStringAsFixed(2));
    averageActivity = double.parse(averageActivity.toStringAsFixed(2));

    // Rounding worked hours for each day
    workedHours.forEach((day, hours) {
      workedHours[day] = double.parse(hours.toStringAsFixed(2));
    });

    return {
      'totalWorkedHours': totalWorkedHours,
      'totalOvertimeHours': totalOvertimeHours,
      'totalNegativeHours': totalNegativeHours,
      'averageActivity': averageActivity,
      'workedHours': workedHours,
    };
  }

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

}
