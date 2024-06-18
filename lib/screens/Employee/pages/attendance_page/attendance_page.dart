import 'package:ams/Animation/animation_controller_mixin.dart';
import 'package:ams/components/hamburger_component/side_overlay.dart';
import 'package:ams/components/user_profile_component/user_profile_component.dart';
import 'package:ams/screens/Employee/pages/attendance_request_page/attendace_request_page.dart';
import 'package:ams/screens/Employee/pages/history_records_page/history_records_page.dart';
import 'package:ams/widgets/button_widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  AttendancePageState createState() => AttendancePageState();
}

class AttendancePageState extends State<AttendancePage>
    with SingleTickerProviderStateMixin, AnimationControllerMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Attendance',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.px,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          const UserProfileIcon(
            backgroundColor: Colors.white,
            icon: Icon(
              CupertinoIcons.person_fill,
              color: Color(0xFF02035d),
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.bars),
            onPressed: toggleOverlay,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  text: 'Check In    Check Out',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendaceRequestPage(),
                      ),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF04045a),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Mark Attendance',
                  onPressed: () {
                    // Handle Mark Attendance
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF04045a),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Attendance Records',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryRecordPage(),
                      ),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF193c86),
                ),
              ],
            ),
          ),
          SideOverlay(animation: offsetAnimation),
        ],
      ),
    );
  }
}
