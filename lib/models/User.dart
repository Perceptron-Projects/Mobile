class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String profileImage;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImage: json['imageUrl'] ?? '',
    );
  }
}
