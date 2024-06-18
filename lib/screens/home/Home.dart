import 'package:flutter/material.dart';
import 'package:ams/components/background.dart';
import 'package:ams/components/customWidget.dart';
import 'package:ams/constants/appColors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:ams/screens/attendance/MarkAttendance.dart';
import 'package:ams/screens/attendance/ViewAttendance.dart';

import 'package:ams/screens/profile/Profile.dart';



class HomePageScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);

    void navigateToScreen(Widget screen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 32.0),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "SyncIn",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                      fontSize: 48,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.0),
                buildNavButton(
                  'Mark Attendance',
                  Icons.check_circle_outline,
                  MarkAttendanceScreen(),
                  navigateToScreen,
                ),
                SizedBox(height: 20),
                buildNavButton(
                  'View Attendance',
                  Icons.visibility,
                  ViewAttendanceScreen(),
                  navigateToScreen,
                ),
                SizedBox(height: 20),
                buildNavButton(
                  'Leave Request',
                  Icons.request_page,
                  MarkAttendanceScreen(),
                  navigateToScreen,
                ),
                SizedBox(height: 20),
                buildNavButton(
                  'Profile',
                  Icons.person,
                  MarkAttendanceScreen(),
                  navigateToScreen,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Adjust the currentIndex based on your logic
        onTap: (index) {
          // Handle the tap event, navigate to different screens
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePageScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
      ),
    );
  }

  Widget buildNavButton(
      String title,
      IconData icon,
      Widget screen,
      Function(Widget) navigateToScreen,
      ) {
    return GestureDetector(
      onTap: () => navigateToScreen(screen),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textColor, size: 24),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
