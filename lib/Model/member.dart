// member.dart

class Member {
  final String name;
  final String memberNumber;
  final int shortLeaves;
  final int halfDays;
  final int fullDays;

  Member({
    required this.name,
    required this.memberNumber,
    required this.shortLeaves,
    required this.halfDays,
    required this.fullDays,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'],
      memberNumber: json['memberNumber'],
      shortLeaves: json['shortLeaves'],
      halfDays: json['halfDays'],
      fullDays: json['fullDays'],
    );
  }
}
