import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ams/components/hamburger_component/side_overlay.dart';
import 'package:ams/components/user_profile_component/user_profile_component.dart';
import 'package:ams/Animation/animation_controller_mixin.dart';
import 'package:ams/screens/Employee/pages/attendance_page/attendance_page.dart';
import 'package:ams/screens/Employee/pages/leave_management.dart/leave_management.dart';
import 'package:ams/widgets/button_widget/button_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  EmployeeDashboardState createState() => EmployeeDashboardState();
}

class EmployeeDashboardState extends State<EmployeeDashboard>
    with SingleTickerProviderStateMixin, AnimationControllerMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Employee Dashboard',
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
                  text: 'Insight Panel',
                  onPressed: () {
                    // Handle Insight Panel
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Attendance',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AttendancePage()),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Calendar',
                  onPressed: () {
                    // Handle Calendar
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Leave Management',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveManagement(),
                      ),
                    );
                    // Handle Leave Management
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
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
