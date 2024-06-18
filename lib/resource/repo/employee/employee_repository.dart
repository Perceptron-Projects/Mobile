import 'package:ams/Model/leave_status_model.dart';

abstract class EmployeeRepository {
  Future<bool> getIsWithinRadius(
      String token, String companyId, String userLat, String userLong);

  Future<dynamic> sendAttendane(String token, Map<String, dynamic> data);
  Future<dynamic> timeofRequest(String token, Map<String, dynamic> data);
  Future<List<LeaveStatusModel>> getAttendanceHistory(
      String token, String employeeId, bool isStatus);
}
