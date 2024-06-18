import 'package:ams/constants/user_role.dart';
import 'package:ams/screens/Employee/pages/employee_dashboard/employee_dashboard.dart';
import 'package:ams/screens/HR/Pages/hr_dashboard/hr_dashboard.dart';
import 'package:ams/screens/Supervisor/pages/supervisor_dashboard/supervisor_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  final UserRole userRole;
  const HomeScreen({super.key, required this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = _getPages(widget.userRole);
  }

  List<Widget> _getPages(UserRole userRole) {
    switch (userRole) {
      case UserRole.supervisor:
        return [
          const SupervisorDashboard(),
          Container(),
          Container(),
          Container(),
        ];
      case UserRole.employee:
        return [
          const EmployeeDashboard(),
          Container(),
          Container(),
          Container(),
        ];
      case UserRole.hr:
        return [
          const HRDashboard(),
          Container(),
          Container(),
          Container(),
        ];
      default:
        return [
          Container(),
          Container(),
          Container(),
          Container(),
        ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF8082ab),
          selectedItemColor: const Color(0xFF6cc9e3),
          type: BottomNavigationBarType.fixed,
          iconSize: 3.h,
          unselectedItemColor: Colors.white,
          selectedFontSize: 10.px,
          unselectedFontSize: 10.px,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_fill),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell_fill),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_fill),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
