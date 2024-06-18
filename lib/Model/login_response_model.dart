class LoginModel {
  final String token;
  final List<String> role;
  final String userId;
  final String companyId;

  LoginModel(
      {required this.token,
      required this.role,
      required this.userId,
      required this.companyId});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'] as String,
      role: List<String>.from(json['role']),
      userId: json['userId'] as String,
      companyId: json['companyId'] ?? '',
    );
  }
}
