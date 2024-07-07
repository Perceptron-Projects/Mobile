import 'package:ams/screens/attendance/EmployeeList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/components/Background.dart';
import 'package:ams/screens/attendance/MarkAttendance.dart';
import 'package:ams/screens/attendance/ViewAttendance.dart';
import 'package:ams/screens/attendance/ViewWFHRequests.dart';
import 'package:ams/screens/supervisor/WorkFromHomeRequests.dart';
import 'package:ams/screens/profile/Profile.dart';
import 'package:ams/screens/home/Home.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:ams/providers/authController.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../providers/ProfileController.dart';
import '../hr/CalenderManagement.dart';
import '../insightPanel/InsightPanel.dart';
import '../welcome/Welcome.dart';

final authControllerProvider = Provider((ref) => AuthController());

class AttendanceDashboardScreen extends ConsumerWidget {
  final String companyId;

  AttendanceDashboardScreen({required this.companyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);


    Future<List<String>> getUserRoles() async {
      try {
        return await authController.getRoles() ?? [];
      } catch (e) {
        print("Error fetching user roles: $e");
        return [];
      }
    }

    void navigateToScreen(Widget screen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }

    return FutureBuilder<List<String>>(
      future: getUserRoles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error fetching user roles"),
            ),
          );
        } else {
          final userRoles = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: Text(
                'My Attendance Dashboard',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            body: Background(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildNavButton(
                        ' Mark Attendance',
                        Icons.check_circle_outline,
                        MarkAttendanceScreen(),
                        navigateToScreen,
                      ),
                      SizedBox(height: 30),
                      buildNavButton(
                        ' View My Attendance',
                        Icons.visibility,
                        ViewAttendanceScreen(),
                        navigateToScreen,
                      ),
                      SizedBox(height: 30),
                      buildNavButton(
                        ' Work From Home History',
                        Icons.account_balance,
                        ViewWFHRequestsScreen(),
                        navigateToScreen,
                      ),
                      SizedBox(height: 30),
                      if (userRoles.contains('hr') || userRoles.contains('supervisor'))
                        buildNavButton(
                          ' Work From Home Requests',
                          Icons.person,
                          SupervisorWFHDashboardScreen(),
                          navigateToScreen,
                        ),
                      SizedBox(height: 30),
                      if (userRoles.contains('hr') || userRoles.contains('supervisor'))
                        buildNavButton(
                          ' Attendance of employees',
                          Icons.record_voice_over,
                          EmployeeListScreen(companyId: companyId),
                          navigateToScreen,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: 0, // Adjust the currentIndex based on your logic
              onTap: (index) async {
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
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()),
                  );
                }
                else if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InsightsScreen()),
                  );
                }
                else if (index == 4) {
                  // Handle logout
                  await ref.read(profileControllerProvider).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
              selectedItemColor: AppColors.buttonColor,
              unselectedItemColor: Colors.grey,
            ),
          );
        }
      },
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
        width: 360, // Adjust the width as needed
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textColor, size: 40),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
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
