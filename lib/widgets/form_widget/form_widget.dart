import 'package:ams/Model/leave_status_model.dart';
import 'package:ams/constants/leave_status.dart';
import 'package:flutter/material.dart';


class LeaveStatusCard extends StatelessWidget {
  final LeaveStatus leaveStatus;
  final LeaveStatusModel leaveStatusModel;
  final VoidCallback? onMorePressed;

  const LeaveStatusCard({
    Key? key,
    required this.leaveStatusModel,
    this.onMorePressed,
    required this.leaveStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${leaveStatusModel.leaveType} Leave',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: leaveStatus.color,
                  radius: 12.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  leaveStatusModel.status,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Leave Period:',
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(width: 5.0),
                Text(
                  '${leaveStatusModel.startDate} - ${leaveStatusModel.endDate}',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onMorePressed,
                child: const Text('More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
