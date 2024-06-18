import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ams/components/hamburger_component/side_overlay.dart';
import 'package:ams/components/user_profile_component/user_profile_component.dart';
import 'package:ams/Animation/animation_controller_mixin.dart';
import 'package:ams/screens/Employee/pages/history_records_page/history_records_page.dart';
import 'package:ams/screens/Employee/pages/leave_status_page/leave_status_page.dart';
import 'package:ams/screens/Employee/pages/time_off_request_page/time_off_request_page.dart';
import 'package:ams/widgets/button_widget/button_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaveManagement extends StatefulWidget {
  const LeaveManagement({super.key});

  @override
  LeaveManagementState createState() => LeaveManagementState();
}

class LeaveManagementState extends State<LeaveManagement>
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
          'Leave Management',
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
              text: 'Time Off Request',
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeOffRequestPage(),
                      ),
                    );
              },
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1A237E),
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
              text: 'Chart Analysis',
              onPressed: () {
                
              },
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1A237E),
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
              text: 'Status',
              onPressed: () { Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveStatusPage(),
                      ),
                    );
                
              },
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1A237E),
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
              text: 'Leave History',
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryRecordPage(),
                      ),
                    );
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