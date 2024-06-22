import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/components/Background.dart';
import 'package:ams/screens/teams/ViewTeams.dart';
import 'package:ams/screens/supervisor/TeamManagementDashboard.dart';
import 'package:ams/screens/profile/Profile.dart';
import 'package:ams/screens/home/Home.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:ams/providers/authController.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authControllerProvider = Provider((ref) => AuthController());

class TeamDashboardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider);
    final isLoading = useState<bool>(true);
    final userRoles = useState<List<String>>([]);

    Future<void> fetchUserRoles() async {
      try {
        userRoles.value = await authController.getRoles() ?? [];
      } catch (e) {
        print("Error fetching user roles: $e");
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      fetchUserRoles();
      return null;
    }, []);

    void navigateToScreen(Widget screen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Team Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Background(
        child: isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildNavButton(
                    'View Teams',
                    Icons.group,
                    ViewTeamsScreen(),
                    navigateToScreen,
                  ),
                  SizedBox(height: 30),
                  if (userRoles.value.contains('supervisor'))
                    buildNavButton(
                      'Manage Teams',
                      Icons.edit,
                      TeamManagementDashboardScreen(),
                      navigateToScreen,
                    ),
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
