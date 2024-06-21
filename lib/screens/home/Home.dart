import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/components/background.dart';
import 'package:ams/providers/AuthController.dart';
import 'package:ams/screens/profile/Profile.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:ams/screens/attendance/AttendanceDashboard.dart';

final authControllerProvider = Provider((ref) => AuthController());

class HomePageScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final firstName = useState<String?>('');
    final screenSize = MediaQuery.of(context).size;

    useEffect(() {
      Future<void> loadUserData() async {
        try {
          var fName = await ref.read(authControllerProvider).getFirstName();
          if (fName != null) {
            firstName.value = fName; // Update the state only if fName is not null
          }
        } catch (e) {
          debugPrint('Error fetching firstName: $e');
        }
      }
      loadUserData();
      return null;
    }, const []);

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
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: screenSize.height * 0.035,
                        color: AppColors.textColor,
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.waving_hand,
                            color: AppColors.white,
                            size: screenSize.height * 0.04,
                          ),
                        ),
                        TextSpan(
                          text: ' Hi ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        TextSpan(
                          text: '${firstName.value ?? "User"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize.height * 0.04,
                            color: AppColors.white,
                          ),
                        ),
                        TextSpan(
                          text: '!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: [
                    buildNavButton(
                      'Attendance',
                      Icons.access_time,
                      AttendanceDashboardScreen(),
                      navigateToScreen,
                    ),
                    buildNavButton(
                      'Profile',
                      Icons.person,
                      ProfileScreen(),
                      navigateToScreen,
                    ),
                    buildNavButton(
                      'Leaves',
                      Icons.person,
                      ProfileScreen(),
                      navigateToScreen,
                    ),
                    buildNavButton(
                      'Calendar',
                      Icons.person,
                      ProfileScreen(),
                      navigateToScreen,
                    )
                  ],
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
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
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
