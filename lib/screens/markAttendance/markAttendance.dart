import 'package:flutter/material.dart';
import 'package:ams/components/background.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/constants/AppFontsSize.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ams/providers/LocationController.dart';

class MarkAttendanceScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;

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
      body: Background(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Check In / Check Out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTextColor,
                fontSize: appFontsSize.bodyFontSize2,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: screenSize.height * 0.05),
            Container(
              width: screenSize.width * 0.8, // 80% of screen width
              height: screenSize.height * 0.6, // 10% of screen height
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(
                    screenSize.width * 0.05), // 5% of screen width
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
                        onPressed: () {},
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
                          minimumSize: Size(screenSize.height * 0.08,
                              screenSize.height * 0.08),
                        ),
                      ),
                      SizedBox(width: 10), // for Add spacing between buttons
                      ElevatedButton(
                        onPressed: () {},
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
                          minimumSize: Size(screenSize.height * 0.08,
                              screenSize.height * 0.08),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LocationSelection(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final Size screenSize = MediaQuery.of(context).size;

    String formattedDate =
        DateFormat('dd').format(now); // Format the date as 'dd' for day
    String formattedDay =
        DateFormat('E').format(now); // Format the day as 'E' for day of week

    return Container(
      padding: EdgeInsets.all(10),
      width: screenSize.width * 0.4,
      height: screenSize.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            formattedDay,
            style: TextStyle(
              fontSize: appFontsSize.bodyFontSize3,
            ),
          ),
        ],
      ),
    );
  }
}

class TimeIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.jm().format(now);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      width: screenSize.width * 0.6,
      height: screenSize.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        formattedTime,
        style: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
