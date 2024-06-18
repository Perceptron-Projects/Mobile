class User {
  final String companyId;
  final String lastName;
  final String branchName;
  final String contactNo;
  final String email;
  final String firstName;
  final String password;
  final String imageUrl;
  final String role;
  final String userId;
  final String joiningDate;
  final String username;
  final String dateOfBirth;
  final String branchId;

  User({
    required this.companyId,
    required this.lastName,
    required this.branchName,
    required this.contactNo,
    required this.email,
    required this.firstName,
    required this.password,
    required this.imageUrl,
    required this.role,
    required this.userId,
    required this.joiningDate,
    required this.username,
    required this.dateOfBirth,
    required this.branchId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      companyId: json['companyId'] as String,
      lastName: json['lastName'] as String,
      branchName: json['branchName'] as String,
      contactNo: json['contactNo'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      password: json['password'] as String,
      imageUrl: json['imageUrl'] as String,
      role: json['role'] as String,
      userId: json['userId'] as String,
      joiningDate: json['joiningDate'] as String,
      username: json['username'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      branchId: json['branchId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'lastName': lastName,
      'branchName': branchName,
      'contactNo': contactNo,
      'email': email,
      'firstName': firstName,
      'password': password,
      'imageUrl': imageUrl,
      'role': role,
      'userId': userId,
      'joiningDate': joiningDate,
      'username': username,
      'dateOfBirth': dateOfBirth,
      'branchId': branchId,
    };
  }
}
