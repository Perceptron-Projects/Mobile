import 'package:ams/screens/insightPanel/InsightPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/components/background.dart';
import 'package:ams/providers/AuthController.dart';
import 'package:ams/providers/ProfileController.dart';
import 'package:ams/screens/profile/Profile.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:ams/screens/attendance/AttendanceDashboard.dart';
import 'package:ams/screens/teams/TeamsDashboard.dart';
import 'package:ams/screens/teams/ViewTeams.dart';
import 'package:ams/screens/leave/LeaveDashboard.dart';
import 'package:ams/screens/hr/CalenderManagement.dart';

final authControllerProvider = Provider((ref) => AuthController());

class HomePageScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final firstName = useState<String?>('');
    final profileImage = useState<String?>('');
    final screenSize = MediaQuery.of(context).size;

    useEffect(() {
      Future<void> loadUserData() async {
        try {
          var userProfile = await ref.read(profileControllerProvider).getProfile();
          if (userProfile != null) {
            firstName.value = userProfile['firstName']; // Update the state with the first name
            profileImage.value = userProfile['imageUrl']; // Update the state with the profile image
          }
        } catch (e) {
          debugPrint('Error fetching user profile: $e');
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

    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning !';
      } else if (hour < 17) {
        return 'Good Afternoon !';
      } else {
        return 'Good Evening !';
      }
    }

    return Scaffold(
      body: Background(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 32.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: screenSize.height * 0.035,
                                    color: AppColors.textColor,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.waving_hand_rounded,
                                        color: Colors.amber,
                                        size: screenSize.height * 0.04,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Hi ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${firstName.value ?? "User"}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenSize.height * 0.04,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' !',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                getGreeting(),
                                style: TextStyle(
                                  fontSize: screenSize.height * 0.02,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                          profileImage.value != null
                              ? GestureDetector(
                            onTap: () => navigateToScreen(ProfileScreen()),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(profileImage.value!),
                              backgroundColor: Colors.grey,
                            ),
                          )
                              : GestureDetector(
                            onTap: () => navigateToScreen(ProfileScreen()),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset(
                        'assets/images/icon/companyLogo.png',
                        height: 100, // Adjust the height as needed
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
                          'Teams',
                          Icons.person,
                          TeamDashboardScreen(),
                          navigateToScreen,
                        ),
                        buildNavButton(
                          'Leaves',
                          Icons.umbrella_rounded,
                          LeaveDashboardScreen(),
                          navigateToScreen,
                        ),
                        buildNavButton(
                          'Calendar',
                          Icons.calendar_month_rounded,
                          InsightPanelScreen(),
                          navigateToScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
