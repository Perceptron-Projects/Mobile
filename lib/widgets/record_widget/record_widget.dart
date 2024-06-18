import 'package:ams/constants/leave_status.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaveStatusCard extends StatelessWidget {
  final LeaveStatus leaveStatus;
  final String fromDate;
  final String toDate;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onMorePressed; // Add a callback for the "More" button

  const LeaveStatusCard({
    super.key,
    required this.leaveStatus,
    required this.fromDate,
    required this.toDate,
    this.backgroundColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.onMorePressed, // Initialize the callback
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(18.0),
      ),
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 2.h,
          ),
      child: Padding(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 1.5.h,
            ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Annual Leave',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.px,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: leaveStatus.color,
                            radius: 1.5.w,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(leaveStatus.toString().split('.').last,
                              style: TextStyle(
                                fontSize: 12.px,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Leave Departure',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.px,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Row(
                      children: [
                        Text(
                          'From: $fromDate',
                          style: TextStyle(
                            fontSize: 12.px,
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text(
                          'To: $toDate',
                          style: TextStyle(
                            fontSize: 12.px,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 1.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onMorePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.px,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
