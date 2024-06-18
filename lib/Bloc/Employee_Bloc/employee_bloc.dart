import 'package:ams/Model/ui_state.dart';
import 'package:ams/resource/Service/network_error.dart';
import 'package:ams/resource/Service/unauthenticated_error_response.dart';
import 'package:ams/resource/repo/employee/employee_repository.dart';
import 'package:ams/resource/repo/employee/employee_repository_impl.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeBloc {
  final EmployeeRepository _employeeRepository;
  final BehaviorSubject<UIState> _isWithinRadiusController;
  final BehaviorSubject<UIState> _attendanceHistoryController;

  EmployeeBloc()
      : _employeeRepository = EmployeeRepositoryImpl(),
        _isWithinRadiusController =
            BehaviorSubject<UIState>.seeded(IdleUIState()),
        _attendanceHistoryController =
            BehaviorSubject<UIState>.seeded(IdleUIState());

  Stream<UIState> get isWithinRadius => _isWithinRadiusController.stream;

  Stream<UIState> get attendanceHistory => _attendanceHistoryController.stream;

  getIsWithinRadius(
      String token, String companyId, String userLat, String userLong) async {
    _isWithinRadiusController.sink.add(LoadingUIState());
    try {
      var result = await _employeeRepository.getIsWithinRadius(
          token, companyId, userLat, userLong);
      _isWithinRadiusController.sink.add(ResultUIState(result));
    } on UnAuthenticatedErrorResponse catch (e) {
      _isWithinRadiusController.sink.add(UnAuthenticatedUIState(e.message));
    } on NetworkError catch (e) {
      _isWithinRadiusController.sink.add(ErrorUIState(e.message));
    } catch (e) {
      _isWithinRadiusController.sink.add(ErrorUIState(e.toString()));
    }
  }

  Future<dynamic> sendAttendane(String token, Map<String, dynamic> data) async {
    return await _employeeRepository.sendAttendane(token, data);
  }

  Future<dynamic> timeofRequest(String token, Map<String, dynamic> data) async {
    return await _employeeRepository.timeofRequest(token, data);
  }

  getAttendanceHistory(String token, String employeeId,
      {bool isStatus = false}) async {
    _attendanceHistoryController.sink.add(LoadingUIState());
    try {
      var result = await _employeeRepository.getAttendanceHistory(
          token, employeeId, isStatus);
      if (result.isEmpty) {
        _attendanceHistoryController.sink.add(NoResultUIState());
      } else {
        _attendanceHistoryController.sink.add(ResultUIState(result));
      }
    } on UnAuthenticatedErrorResponse catch (e) {
      _attendanceHistoryController.sink.add(UnAuthenticatedUIState(e.message));
    } on NetworkError catch (e) {
      _attendanceHistoryController.sink.add(ErrorUIState(e.message));
    } catch (e) {
      _attendanceHistoryController.sink.add(ErrorUIState(e.toString()));
    }
  }

  void dispose() {
    _isWithinRadiusController.close();
  }
}
