import 'package:flutter/material.dart';

enum LeaveStatus {
  Approved,
  Pending,
  Rejected,
}

extension LeaveStatusExtension on LeaveStatus {
  Color get color {
    switch (this) {
      case LeaveStatus.Approved:
        return Colors.green;
      case LeaveStatus.Pending:
        return Colors.yellow;
      case LeaveStatus.Rejected:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
