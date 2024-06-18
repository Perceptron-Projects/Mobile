import 'package:ams/Model/login_response_model.dart';
import 'package:ams/resource/Service/error_response.dart';
import 'package:ams/resource/Service/http_service.dart';
import 'package:ams/resource/repo/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HttpService _httpService;

  final String loginPath = '/users/login';

  AuthRepositoryImpl() : _httpService = HttpService();

  @override
  Future<LoginModel> login(Map<String, dynamic> data) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    var response =
        await _httpService.postFormData(loginPath, data, headers: headers);

    if (!response.containsKey('error')) {
      LoginModel loginModel = LoginModel.fromJson(response);
      return loginModel;
    } else {
      throw ErrorResponse(message: response['error'],status: 500);
    }
  }
}
