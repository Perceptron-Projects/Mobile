import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ams/Animation/animation_controller_mixin.dart';
import 'package:ams/Bloc/Auth_Bloc/auth_bloc.dart';
import 'package:ams/Bloc/Employee_Bloc/employee_bloc.dart';
import 'package:ams/Model/ui_state.dart';
import 'package:ams/components/hamburger_component/side_overlay.dart';
import 'package:ams/components/user_profile_component/user_profile_component.dart';
import 'package:ams/resource/Provider/provider.dart';
import 'package:ams/screens/login/login.dart';
import 'package:ams/widgets/custom_error.dart';
import 'package:geolocator/geolocator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AttendaceRequestPage extends StatefulWidget {
  const AttendaceRequestPage({super.key});

  @override
  State<AttendaceRequestPage> createState() => _AttendaceRequestPageState();
}

class _AttendaceRequestPageState extends State<AttendaceRequestPage>
    with SingleTickerProviderStateMixin, AnimationControllerMixin {
  late AuthBloc authBloc;

  late EmployeeBloc employeeBloc;

  Future<Position> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // You might want to notify the user that location services are disabled
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Notify user that permission was denied
          await Geolocator.openAppSettings();
          await Geolocator.openLocationSettings();
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Notify user that permission is permanently denied
        await Geolocator.openAppSettings();
        await Geolocator.openLocationSettings();
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position position = await Geolocator.getCurrentPosition();

      callGetIsWithinRadius(
          position.latitude.toString(), position.longitude.toString());

      return position;
    } catch (e) {
      return Future.error(
          'An error occurred while determining the position: $e');
    }
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  callGetIsWithinRadius(String userLat, String userLong) {
    employeeBloc.getIsWithinRadius(
      authBloc.getSavedUserToken(),
      authBloc.getCompanyId(),
      userLat,
      userLong,
    );
  }

  @override
  Widget build(BuildContext context) {
    authBloc = Provider.of(context).authBloc;
    employeeBloc = Provider.of(context).employeeBloc;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Attendance Request',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.px,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          const UserProfileIcon(
            backgroundColor: Colors.white,
            icon: Icon(
              CupertinoIcons.person_fill,
              color: Color(0xFF02035d),
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.bars),
            onPressed: toggleOverlay,
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: _determinePosition(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder<UIState>(
                    stream: employeeBloc.isWithinRadius,
                    builder: (context, snapshotData) {
                      if (snapshotData.hasData) {
                        UIState uiState = snapshotData.data!;
                        if (uiState is LoadingUIState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (uiState is ResultUIState) {
                          bool status = uiState.result;
                          return ResultUI(status: status);
                        } else if (uiState is UnAuthenticatedUIState) {
                          logout();
                          return const SizedBox.shrink();
                        } else if (uiState is ErrorUIState) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 20, top: 24),
                            child: CustomError(
                              errorMsg: uiState.message,
                              callBack: () {
                                setState(() {});
                                callGetIsWithinRadius(
                                  snapshot.data!.latitude.toString(),
                                  snapshot.data!.longitude.toString(),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    )),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
          SideOverlay(animation: offsetAnimation),
        ],
      ),
    );
  }
}

class ResultUI extends StatefulWidget {
  final bool status;
  const ResultUI({super.key, required this.status});

  @override
  State<ResultUI> createState() => _ResultUIState();
}

class _ResultUIState extends State<ResultUI> {
  late EmployeeBloc employeeBloc;
  late AuthBloc authBloc;

  bool isLoadingCheckIn = false;
  bool isLoadingCheckOut = false;

  String _getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('dd EEE').format(now);
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return DateFormat('hh:mm a').format(now);
  }

  void callAttendance(int type) {
    setState(() {
      if (type == 0) {
        isLoadingCheckIn = true;
      } else {
        isLoadingCheckOut = true;
      }
    });

    Map<String, dynamic> formData = {
      "employeeId": authBloc.getUserId(),
      "companyId": authBloc.getCompanyId(),
      "time": DateTime.now().toIso8601String(),
      "isCheckedIn": type == 0,
      "isCheckedOut": type != 0,
      "isWorkFromHome": false
    };

    employeeBloc
        .sendAttendane(authBloc.getSavedUserToken(), formData)
        .then((user) {
      setState(() {
        if (type == 0) {
          isLoadingCheckIn = false;
        } else {
          isLoadingCheckOut = false;
        }
      });
      print(user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success')),
      );
    }).catchError((error) {
      setState(() {
        if (type == 0) {
          isLoadingCheckIn = false;
        } else {
          isLoadingCheckOut = false;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.message}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    employeeBloc = Provider.of(context).employeeBloc;
    authBloc = Provider.of(context).authBloc;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: const Text(
              'Check In',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AttendanceCard(
              formattedDate: _getFormattedDate(),
              formattedTime: _getFormattedTime(),
              selectedLocation: !widget.status ? 'Office' : 'Home',
              primaryButtonLabel: 'Request',
              primaryButtonColor:
                  !widget.status ? Colors.grey[400]! : Colors.black,
              primaryButtonOnPressed: () {},
              secondaryButtonLabel: 'Check In',
              secondaryButtonColor:
                  !widget.status ? Colors.black : Colors.grey[400]!,
              secondaryButtonOnPressed: () {
                callAttendance(0);
              },
              isLoading: isLoadingCheckIn,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: const Text(
              'Check Out',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AttendanceCard(
              formattedDate: _getFormattedDate(),
              formattedTime: _getFormattedTime(),
              selectedLocation: !widget.status ? 'Office' : 'Home',
              primaryButtonLabel: '',
              primaryButtonColor:
                  !widget.status ? Colors.grey[400]! : Colors.black,
              primaryButtonOnPressed: () {},
              secondaryButtonLabel: 'Check Out',
              secondaryButtonColor:
                  !widget.status ? Colors.black : Colors.grey[400]!,
              secondaryButtonOnPressed: () {
                callAttendance(1);
              },
              isLoading: isLoadingCheckOut,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final String formattedDate;
  final String formattedTime;
  final String selectedLocation;
  final String primaryButtonLabel;
  final Color primaryButtonColor;
  final VoidCallback primaryButtonOnPressed;
  final String? secondaryButtonLabel;
  final Color? secondaryButtonColor;
  final VoidCallback? secondaryButtonOnPressed;
  final bool isLoading;

  const AttendanceCard({
    super.key,
    required this.formattedDate,
    required this.formattedTime,
    required this.selectedLocation,
    required this.primaryButtonLabel,
    required this.primaryButtonColor,
    required this.primaryButtonOnPressed,
    this.secondaryButtonLabel,
    this.secondaryButtonColor,
    this.secondaryButtonOnPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28.w,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      formattedDate.split(' ')[0],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate.split(' ')[1],
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 50.w,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedTime.split(' ')[0],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        formattedTime.split(' ')[1],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<String>(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.lightGreen;
                  }
                  return Colors.black;
                }),
                value: 'Home',
                groupValue: selectedLocation,
                onChanged: null,
              ),
              const Text('Home'),
              Radio<String>(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.lightGreen;
                  }
                  return Colors.black;
                }),
                value: 'Office',
                groupValue: selectedLocation,
                onChanged: null,
              ),
              const Text('Office'),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (primaryButtonLabel.isNotEmpty)
                ElevatedButton(
                  onPressed: primaryButtonOnPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryButtonColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(primaryButtonLabel),
                ),
              ElevatedButton(
                onPressed: secondaryButtonOnPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryButtonColor,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator())
                    : Text(secondaryButtonLabel!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
