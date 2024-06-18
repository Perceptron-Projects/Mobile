import 'package:ams/Model/login_response_model.dart';
import 'package:ams/constants/user_role.dart';
import 'package:ams/resource/repo/auth/auth_repository.dart';
import 'package:ams/resource/repo/auth/auth_repository_impl.dart';

class AuthBloc {
  late String _userToken = "";
  late String _companyId = "";
  late String _userId = "";
  late UserRole _userRole;

  static final AuthBloc _bloc = AuthBloc._constructor();

  factory AuthBloc() => _bloc;

  final AuthRepository _authRepository;

  AuthBloc._constructor() : _authRepository = AuthRepositoryImpl();

  //User Token
  String getSavedUserToken() {
    return _userToken;
  }

  setToken(String token) {
    _userToken = token;
  }

  //Company Id
  String getCompanyId() {
    return _companyId;
  }

  setCompanyId(String companyId) {
    _companyId = companyId;
  }

  //User Id
  String getUserId() {
    return _userId;
  }

  setUserId(String userId) {
    _userId = userId;
  }

  //User Role

  UserRole getUserRole() {
    return _userRole;
  }

  setUserRole(UserRole userRole) {
    _userRole = userRole;
  }

  Future<LoginModel> login(Map<String, dynamic> data) async {
    return await _authRepository.login(data);
  }
}
