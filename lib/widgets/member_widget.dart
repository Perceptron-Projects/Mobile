import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MemberWidget extends StatelessWidget {
  final String name;
  final String memberNumber;
  final int shortLeaves;
  final int halfDays;
  final int fullDays;

  const MemberWidget({
    super.key,
    required this.name,
    required this.memberNumber,
    required this.shortLeaves,
    required this.halfDays,
    required this.fullDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 6.0.w,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(width: 4.0.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        TextStyle(fontSize: 4.0.w, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    memberNumber,
                    style: TextStyle(fontSize: 3.0.w),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 30.w,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 15.w),
              Text(
                'SL: $shortLeaves', // Display short leaves
                style: TextStyle(fontSize: 4.0.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4.0.w), // Add spacing between text elements
              Text(
                'HD: $halfDays', // Display half days
                style: TextStyle(fontSize: 4.0.w, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4.0.w), // Add spacing between text elements
              Text(
                'FD: $fullDays', // Display full days
                style: TextStyle(fontSize: 4.0.w, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
