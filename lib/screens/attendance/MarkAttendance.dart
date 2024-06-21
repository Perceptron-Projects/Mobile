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
import 'package:intl/intl.dart';

class MarkAttendanceScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final workFromHomeLoading = useState(false);
    final screenSize = MediaQuery.of(context).size;

    // State variables to hold the attendance status
    final isCheckedIn = useState<bool>(false);
    final isCheckedOut = useState<bool>(false);
    final isWorkFromHomeApproved = useState<bool>(false);
    final showSnackbar = useState<String?>(null);
    final selectedDate = useState<DateTime>(DateTime.now());
    final workFromHomeStatus = useState<String>('');

    // Fetch the initial attendance and work-from-home status once
    useEffect(() {
      final attendanceController = ref.read(attendanceControllerProvider);

      attendanceController.getAttendanceStatus().then((status) {
        isCheckedIn.value = status['isCheckedIn'] ?? false;
        isCheckedOut.value = status['isCheckedOut'] ?? false;
      }).catchError((error) {
        throw error;
      });

      attendanceController.getWorkFromHomeStatus(DateTime.now()).then((status) {
        workFromHomeStatus.value = status;
        print(workFromHomeStatus.value);
        isWorkFromHomeApproved.value = status == 'approved';
        print(isWorkFromHomeApproved.value);
      }).catchError((error) {
        throw error;
      });
    }, []);

    void showCustomSnackbar(String message) {
      showSnackbar.value = message;
      Future.delayed(Duration(seconds: 3), () {
        showSnackbar.value = null;
      });
    }


    void handleWorkFromHomeRequest() async {
      workFromHomeLoading.value = true;
      try {
        await ref.read(attendanceControllerProvider).sendWorkFromHomeRequest(selectedDate.value);
        showCustomSnackbar('Work from home request submitted successfully.');
        // Update work from home status
        ref.read(attendanceControllerProvider).getWorkFromHomeStatus(selectedDate.value).then((status) {
          workFromHomeStatus.value = status;
          isWorkFromHomeApproved.value = status == 'approved';
        }).catchError((error) {
          showCustomSnackbar('Error: $error');
          print('Error fetching updated work from home status: $error');
        });
      } catch (e) {
        showCustomSnackbar('Failed to submit work from home request: $e');
      } finally {
        workFromHomeLoading.value = false;
      }
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
        // Fetch work from home status for the selected date
        ref.read(attendanceControllerProvider).getWorkFromHomeStatus(picked).then((status) {
          workFromHomeStatus.value = status;
          isWorkFromHomeApproved.value = status == 'approved';
        }).catchError((error) {
          throw error;
        });
      }
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.0),
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
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(screenSize.width * 0.05), // 5% of screen width
                    ),
                    margin: EdgeInsets.only(top: 5),
                    alignment: Alignment.topCenter,
                    //padding: EdgeInsets.symmetric(horizontal: 5),
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

                                  bool withinRadius = true;
                                  if (!isWorkFromHomeApproved.value) {
                                    withinRadius = await locationController.isWithinCompanyRadius();
                                  }

                                  if (withinRadius) {
                                    await attendanceController.markAttendance(true, false, isWorkFromHomeApproved.value);
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

                                  bool withinRadius = true;
                                  if (!isWorkFromHomeApproved.value) {
                                    withinRadius = await locationController.isWithinCompanyRadius();
                                  }

                                  if (withinRadius) {
                                    await attendanceController.markAttendance(false, true, isWorkFromHomeApproved.value);
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
                  SizedBox(height: screenSize.height * 0.02),
                  const Text(
                    'Work From Home Requests',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTextColor,
                      fontSize: appFontsSize.bodyFontSize2,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Container(
                    width: screenSize.width * 0.8, // 80% of screen width
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(screenSize.width * 0.05), // 5% of screen width
                    ),
                    margin: EdgeInsets.only(top: 5),
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: screenSize.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                'Select Date',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                minimumSize: Size(screenSize.height * 0.05, screenSize.height * 0.05),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: workFromHomeLoading.value
                                  ? null
                                  : () async {
                                handleWorkFromHomeRequest();
                              },
                              child: Text(
                                'Request',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                minimumSize: Size(screenSize.height * 0.05, screenSize.height * 0.05),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.025),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 10),
                            Text(
                              DateFormat('yyyy-MM-dd').format(selectedDate.value),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            Text(
                              ' WFH Status: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            Icon(
                              isWorkFromHomeApproved.value ? Icons.check_circle : Icons.cancel,
                              color: isWorkFromHomeApproved.value ? Colors.green : Colors.red,
                              size: 30,
                            ),
                            Text(
                              workFromHomeStatus.value,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isWorkFromHomeApproved.value ? Colors.green : Colors.red,
                              ),
                            ),
                            SizedBox(width: 10),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
}
