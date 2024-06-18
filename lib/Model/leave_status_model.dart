class LeaveStatusModel {
  final String startTime;
  final String employeeId;
  final String endTime;
  final String companyId;
  final String endDate;
  final String status;
  final String leaveId;
  final String startDate;
  final String createdAt;
  final String name;
  final String reason;
  final String leaveType;

  LeaveStatusModel({
    required this.startTime,
    required this.employeeId,
    required this.endTime,
    required this.companyId,
    required this.endDate,
    required this.status,
    required this.leaveId,
    required this.startDate,
    required this.createdAt,
    required this.name,
    required this.reason,
    required this.leaveType,
  });

  factory LeaveStatusModel.fromJson(Map<String, dynamic> json) {
    return LeaveStatusModel(
      startTime: json['startTime'] as String,
      employeeId: json['employeeId'] as String,
      endTime: json['endTime'] as String,
      companyId: json['companyId'] as String,
      endDate: json['endDate'] as String,
      status: json['status'] as String,
      leaveId: json['leaveId'] as String,
      startDate: json['startDate'] as String,
      createdAt: json['createdAt'] as String,
      name: json['name'] as String,
      reason: json['reason'] as String,
      leaveType: json['leaveType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'employeeId': employeeId,
      'endTime': endTime,
      'companyId': companyId,
      'endDate': endDate,
      'status': status,
      'leaveId': leaveId,
      'startDate': startDate,
      'createdAt': createdAt,
      'name': name,
      'reason': reason,
      'leaveType': leaveType,
    };
  }
}
