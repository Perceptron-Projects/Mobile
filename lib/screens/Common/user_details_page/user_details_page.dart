import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ams/widgets/check_in_out_widget/check_in_out_widget.dart';
import 'package:ams/widgets/remaining_leaves_widget/remaining_leaves_widget.dart';
import 'package:ams/widgets/stats_row_widget/stats_row_widget.dart';
import 'package:ams/widgets/worked_hours_widget/worked_hours_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Dummy data list
    List<Map<String, dynamic>> checkInOutData = [
      {'EID': '', 'Date': 'Date1'},
      {'EID': 'EID2', 'Date': 'Date2'},
      // Add more items here
    ];
    const String imageUrl =
        'https://via.placeholder.com/150'; // Replace with your image URL
    const String name = 'Manton James';
    const String title = 'Project Manager';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Employee Advanced Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.px,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    radius: 50,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                ],
              ),
            ),
            Text(
              "General",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const StatsRow(
              label: 'No of Casual Leaves Taken',
              value: 06,
              maValue: 10,
            ),
            const StatsRow(
              label: 'No of Half Day Taken',
              value: 01,
              maValue: 10,
            ),
            const StatsRow(
              label: 'No of Maternity Leaves Taken',
              value: 02,
              maValue: 10,
            ),
            const StatsRow(
              label: 'No of Short Leaves Taken',
              value: 00,
              maValue: 10,
            ),
            SizedBox(
              height: 4.h,
            ),
            const WorkedHoursWidget(),
            SizedBox(
              height: 2.h,
            ),
            const RemainingLeavesWidget(),
            SizedBox(
              height: 2.h,
            ),
            Text(
              "Check in/Check out",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            for (var data in checkInOutData) ...[
              CheckInOutWidget(data: data),
              SizedBox(
                height: 1.h,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
