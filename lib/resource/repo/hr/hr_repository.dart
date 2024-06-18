import 'package:ams/Model/user_modle.dart';

abstract class HRRepository {
  Future<List<User>> getAllUsers(String token, String companyId);
}
