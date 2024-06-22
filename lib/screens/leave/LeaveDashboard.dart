import 'package:ams/screens/leave/RequestLeave.dart';
import 'package:ams/screens/leave/ViewLeaveRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/components/Background.dart';
import 'package:ams/screens/hr/ReviewLeaveRequests.dart';
import 'package:ams/screens/profile/Profile.dart';
import 'package:ams/screens/home/Home.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:ams/providers/authController.dart';
import 'package:ams/providers/leaveController.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authControllerProvider = Provider((ref) => AuthController());

class LeaveDashboardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final leaveController = ref.read(leaveControllerProvider);
    final leaveCounts = useState<Map<String, dynamic>>({});
    final isLoading = useState<bool>(true);

    Future<void> fetchLeaveCounts() async {
      final storage = FlutterSecureStorage();
      String? employeeId = await storage.read(key: 'userId');
      if (employeeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found')),
        );
        isLoading.value = false;
        return;
      }

      try {
        leaveCounts.value = await leaveController.getLeaveCounts(employeeId);
      } catch (e) {
        print('Error fetching leave counts: $e');
      } finally {
        isLoading.value = false;
      }
    }

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

    useEffect(() {
      fetchLeaveCounts();
      return null;
    }, []);

    return FutureBuilder<List<String>>(
      future: getUserRoles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isLoading.value) {
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
                'My Leave Dashboard',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            body: Background(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildNavButton(
                          'Request Leaves',
                          Icons.note_add,
                          RequestLeaveScreen(),
                          navigateToScreen,
                        ),
                        SizedBox(height: 30),
                        buildNavButton(
                          'View Leave Requests',
                          Icons.visibility,
                          ViewLeaveRequestsScreen(),
                          navigateToScreen,
                        ),
                        SizedBox(height: 30),
                        if (userRoles.contains('hr'))
                          buildNavButton(
                            'Review Leave Requests',
                            Icons.assignment_turned_in,
                            HRReviewLeaveRequestsScreen(),
                            navigateToScreen,
                          ),
                        SizedBox(height: 30),
                        Text(
                          'Remaining Leaves',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellowAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        LeaveCountsGrid(leaveCounts: leaveCounts.value),
                      ],
                    ),
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
            SizedBox(width: 10),
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
