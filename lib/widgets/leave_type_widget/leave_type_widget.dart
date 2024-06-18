import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaveTypeWidget extends StatelessWidget {
  final String leaveType;
  final String leaveCount;

  const LeaveTypeWidget(
      {Key? key, required this.leaveType, required this.leaveCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 1.h,
      ),
      color: Colors.grey.shade200,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          leaveType,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
        trailing: Text(
          leaveCount,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
