import 'package:ams/Model/user_modle.dart';
import 'package:ams/resource/Service/http_service.dart';
import 'package:ams/resource/repo/hr/hr_repository.dart';

class HRRepositoryImpl extends HRRepository {
  final HttpService _httpService;

  HRRepositoryImpl() : _httpService = HttpService();

  final String pathAllUsers = '/users/company/employees';

  @override
  Future<List<User>> getAllUsers(String token, String companyId) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      "Authorization": 'Bearer $token',
    };
    var response =
        await _httpService.get('$pathAllUsers/$companyId', headers: headers);

    if (_isDataEmpty(response)) {
      return [];
    } else {
      List<User> userList = [];
      userList = List<User>.from(
          response.map((item) => User.fromJson(item)));
      return userList;
    }
  }

  bool _isDataEmpty(dynamic data) {
    if (data is List<dynamic> && data.isEmpty) {
      return true;
    }
    return false;
  }
}
