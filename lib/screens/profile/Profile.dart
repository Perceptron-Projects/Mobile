import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/providers/ProfileController.dart';
import 'package:ams/screens/welcome/Welcome.dart';
import 'package:ams/screens/profile/EditProfile.dart';
import '../../components/CustomWidget.dart';
import '../home/Home.dart';
import '../hr/CalenderManagement.dart';
import '../insightPanel/InsightPanel.dart';

class ProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = useState<Map<String, dynamic>?>(null);
    final isLoading = useState(true);
    final errorMessage = useState<String?>(null);
    final isProfileUpdated = useState(false);

    useEffect(() {
      if (isProfileUpdated.value) {
        ref.read(profileControllerProvider).getProfile().then((data) {
          profile.value = data;
          isLoading.value = false;
          isProfileUpdated.value = false; // Reset the flag
        }).catchError((error) {
          errorMessage.value = error.toString();
          isLoading.value = false;
          isProfileUpdated.value = false; // Reset the flag
        });
      } else {
        ref.read(profileControllerProvider).getProfile().then((data) {
          profile.value = data;
          isLoading.value = false;
        }).catchError((error) {
          errorMessage.value = error.toString();
          isLoading.value = false;
        });
      }
    }, [isProfileUpdated.value]);

    Future<void> handleLogout() async {
      await ref.read(profileControllerProvider).logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
            (route) => false,
      );
    }

    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.value != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Text(errorMessage.value!),
        ),
      );
    }

    final profileData = profile.value ?? {};
    final firstName = profileData['firstName'] ?? 'N/A';
    final lastName = profileData['lastName'] ?? 'N/A';
    final userId = profileData['userId']?.toString() ?? 'N/A';
    final birthday = profileData['birthday'] ?? 'N/A';
    final joinedDate = profileData['joinday'] ?? 'N/A';
    final contactNo = profileData['contactNo'] ?? 'N/A';
    final email = profileData['email'] ?? 'N/A';

    final defaultProfileImageUrl = 'assets/images/defaultProfileImage.jpg';
    final profilePhotoUrl = profileData['imageUrl'] ?? defaultProfileImageUrl;



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    profileData: profileData,
                    onProfileUpdated: (updatedProfile) {
                      profile.value = updatedProfile;
                      isProfileUpdated.value = true; // Set the flag
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'General',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              CircleAvatar(
                radius: 100,
                backgroundImage: profilePhotoUrl.isNotEmpty
                    ? NetworkImage(profilePhotoUrl)
                    : AssetImage(defaultProfileImageUrl) as ImageProvider,
              ),
              SizedBox(height: 16),
              ProfileInfoItem(
                label: 'Name',
                value: firstName + " " + lastName,
              ),
              ProfileInfoItem(
                label: 'Employee ID',
                value: userId,
              ),
              ProfileInfoItem(
                label: 'Email',
                value: email,
              ),
              ProfileInfoItem(
                label: 'Contact No',
                value: contactNo,
              ),
              ProfileInfoItem(
                label: 'Birthday',
                value: birthday,
              ),
              ProfileInfoItem(
                label: 'Joined Date',
                value: joinedDate,
              ),
              SizedBox(height: 48),
              ElevatedButton(
                onPressed: handleLogout,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Adjust the currentIndex based on your logic
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
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InsightsScreen()),
            );
          } else if (index == 4) {
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
}

class ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
