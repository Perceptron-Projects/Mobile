import 'package:ams/Model/leave_status_model.dart';
import 'package:ams/resource/Service/error_response.dart';
import 'package:ams/resource/Service/http_service.dart';
import 'package:ams/resource/repo/employee/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final HttpService _httpService;

  EmployeeRepositoryImpl() : _httpService = HttpService();

  final String pathGetIsWithinRadius = '/users/isWithinRadius';
  final String pathAttendance = '/users/attendance/mark';
  final String pathTimeOfRequest = '/users/employees/leave/request';
  final String pathLeaveHistory = '/users/employees/leave';

  @override
  Future<bool> getIsWithinRadius(
      String token, String companyId, String userLat, String userLong) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      "Authorization": 'Bearer $token',
    };

    Map<String, String> params = {
      'userLat': userLat,
      "userLon": userLong,
    };

    var response = await _httpService.get('$pathGetIsWithinRadius/$companyId',
        headers: headers, queryParams: params);

    return response['withinRadius'];
  }

  @override
  Future<dynamic> sendAttendane(String token, Map<String, dynamic> data) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      "Authorization": 'Bearer $token',
    };
    var response =
        await _httpService.postFormData(pathAttendance, data, headers: headers);

    if (!response.containsKey('error')) {
      return response;
    } else {
      throw ErrorResponse(message: response['error'], status: 500);
    }
  }

  @override
  Future<dynamic> timeofRequest(String token, Map<String, dynamic> data) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      "Authorization": 'Bearer $token',
    };
    var response = await _httpService.postFormData(pathTimeOfRequest, data,
        headers: headers);

    if (!response.containsKey('error')) {
      return response;
    } else {
      throw ErrorResponse(message: response['error'], status: 500);
    }
  }

  @override
  Future<List<LeaveStatusModel>> getAttendanceHistory(
      String token, String employeeId, bool isStatus) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      "Authorization": 'Bearer $token',
    };
    var response = await _httpService.get('$pathLeaveHistory/$employeeId',
        headers: headers);

    if (_isDataEmpty(response)) {
      return [];
    } else {
      List<LeaveStatusModel> leaveList = [];
      if (isStatus) {
        leaveList = List<LeaveStatusModel>.from(response
            .where((item) => item['status'] != 'rejected')
            .map((item) => LeaveStatusModel.fromJson(item)));
        return leaveList;
      } else {
        List<LeaveStatusModel> leaveList = [];
        leaveList = List<LeaveStatusModel>.from(
            response.map((item) => LeaveStatusModel.fromJson(item)));
        return leaveList;
      }
    }
  }

  bool _isDataEmpty(dynamic data) {
    if (data is List<dynamic> && data.isEmpty) {
      return true;
    }
    return false;
  }
}
