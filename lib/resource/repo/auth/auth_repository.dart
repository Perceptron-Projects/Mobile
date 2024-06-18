import 'package:ams/Model/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginModel> login(Map<String, dynamic> data);
}
