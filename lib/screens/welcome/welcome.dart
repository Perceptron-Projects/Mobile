import 'package:flutter/material.dart';
import 'package:ams/components/background.dart';
import 'package:ams/screens/login/login.dart';
import 'package:ams/constants/appColors.dart';
import 'package:ams/constants/appFontsSize.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "Power up your company!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextColor,
                  fontSize: appFontsSize.headingFontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "\"Empower your workforce with precision and care. Where time is valued, and leave is respected. Welcome to a seamless journey of Attendance and Leave Management, where productivity meets balance.\"",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: AppColors.secondaryTextColor,
                  fontSize: appFontsSize.bodyFontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.06),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  backgroundColor: AppColors.whiteButtonColor,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.3,
                  child: Text(
                    "Let's Go!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: appFontsSize.buttonFontSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

