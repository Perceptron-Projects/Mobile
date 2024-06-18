import 'package:ams/screens/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/components/background.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/constants/AppFontsSize.dart';
import 'package:ams/providers/LocationController.dart';
import 'package:ams/providers/AttendanceController.dart';
import 'package:ams/components/CustomWidget.dart';
import 'package:ams/screens/profile/Profile.dart';
import 'package:ams/screens/home/Home.dart';

class MarkAttendanceScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final screenSize = MediaQuery.of(context).size;

    // State variables to hold the attendance status
    final isCheckedIn = useState<bool>(false);
    final isCheckedOut = useState<bool>(false);
    final showSnackbar = useState<String?>(null);

    // Fetch the initial attendance status once
    useEffect(() {
      ref.read(attendanceControllerProvider).getAttendanceStatus().then((status) {
        isCheckedIn.value = status['isCheckedIn'] ?? false;
        isCheckedOut.value = status['isCheckedOut'] ?? false;
      }).catchError((error) {
        throw  error;
      });
    }, []);

    void showCustomSnackbar(String message) {
      showSnackbar.value = message;
      Future.delayed(Duration(seconds: 3), () {
        showSnackbar.value = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Attendance Requests',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

      ),

      body: Stack(

        children: [
          Background(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenSize.height * 0.01),
                const Text(
                  'Check In / Check Out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTextColor,
                    fontSize: appFontsSize.bodyFontSize2,

                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Container(
                  width: screenSize.width * 0.8, // 80% of screen width
                  height: screenSize.height * 0.6, // 60% of screen height
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(screenSize.width * 0.05), // 5% of screen width
                  ),
                  margin: EdgeInsets.only(top: 5),
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      DateIndicator(),
                      SizedBox(height: screenSize.height * 0.03),
                      TimeIndicator(),
                      SizedBox(height: screenSize.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: isLoading.value || isCheckedIn.value
                                ? null
                                : () async {
                              if (isCheckedIn.value) {
                                showCustomSnackbar('Already checked in');
                                return;
                              }
                              isLoading.value = true;

                              try {
                                final locationController = ref.read(locationControllerProvider);
                                final attendanceController = ref.read(attendanceControllerProvider);

                                final withinRadius = await locationController.isWithinCompanyRadius();
                                if (withinRadius) {
                                  await attendanceController.markAttendance(true, false);
                                  showCustomSnackbar('Checked IN successfully');
                                  // Update the attendance status
                                  isCheckedIn.value = true;
                                  isCheckedOut.value = false;
                                } else {
                                  showCustomSnackbar('You are not within the company premises');
                                }
                              } catch (e) {
                                print(e);
                                if (e.toString().contains('You are already checked in')) {
                                  showCustomSnackbar('You are already checked in');
                                } else {
                                  showCustomSnackbar('Failed to mark attendance: $e');
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                            child: Text(
                              'IN',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: Size(screenSize.height * 0.08, screenSize.height * 0.08),
                            ),
                          ),
                          SizedBox(width: 10), // Add spacing between buttons
                          ElevatedButton(
                            onPressed: isLoading.value || isCheckedOut.value
                                ? null
                                : () async {
                              if (isCheckedOut.value) {
                                showCustomSnackbar('Already checked out');
                                return;
                              }
                              isLoading.value = true;

                              try {
                                final locationController = ref.read(locationControllerProvider);
                                final attendanceController = ref.read(attendanceControllerProvider);

                                final withinRadius = await locationController.isWithinCompanyRadius();
                                if (withinRadius) {
                                  await attendanceController.markAttendance(false, true);
                                  showCustomSnackbar('Checked OUT successfully');
                                  // Update the attendance status
                                  isCheckedIn.value = false;
                                  isCheckedOut.value = true;
                                } else {
                                  showCustomSnackbar('You are not within the company premises');
                                }
                              } catch (e) {
                                print(e);
                                if (e.toString().contains('You are already checked out')) {
                                  showCustomSnackbar('You are already checked out');
                                } else {
                                  showCustomSnackbar('Failed to mark attendance: $e');
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                            child: Text(
                              'OUT',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              minimumSize: Size(screenSize.height * 0.08, screenSize.height * 0.08),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: isLoading.value
                                ? null
                                : () async {
                              final locationController = ref.read(locationControllerProvider);

                              try {
                                await locationController.resetLocationPermissions();
                                showCustomSnackbar('Location permissions reset. Please allow location access.');
                              } catch (e) {
                                print(e);
                                showCustomSnackbar('Failed to reset location permissions: $e');
                              }
                            },
                            child: Text(
                              'Reset Location Permissions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(screenSize.height * 0.03, screenSize.height * 0.03),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showSnackbar.value != null)
            CustomSnackbar(message: showSnackbar.value!),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Adjust the currentIndex based on your logic
        onTap: (index) {
          // Handle the tap event, navigate to different screens
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
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
}

