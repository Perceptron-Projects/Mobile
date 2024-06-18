import 'package:ams/Animation/animation_controller_mixin.dart';
import 'package:ams/components/hamburger_component/side_overlay.dart';
import 'package:ams/components/user_profile_component/user_profile_component.dart';
import 'package:ams/screens/Common/all_employee_page/all_employee_page.dart';
import 'package:ams/screens/Common/calendar_events_page/calendar_events_page.dart';
import 'package:ams/screens/Supervisor/pages/request_page/request_page.dart';
import 'package:ams/screens/Supervisor/pages/team_page/team_page.dart';
import 'package:ams/widgets/button_widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard>
    with SingleTickerProviderStateMixin, AnimationControllerMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Supervisor Dashboard',
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
                  text: 'Request',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RequestPage()),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Calender',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeeklyEventCalendar()),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Accounts',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmployeeListScreen()),
                    );
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1A237E),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Teams',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TeamPage()),
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
