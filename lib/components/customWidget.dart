import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ams/constants/AppFontsSize.dart';


typedef Validator = String? Function(String?);

class CustomWidgets {
  
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    return null;
  }

  static Widget buildTextField(
      String label, 
      IconData icon, 
      TextEditingController controller,
      {bool obscureText = false,
      Validator? validator, required TextStyle labelStyle,
      }
      ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle ?? TextStyle(color: Colors.white), // Use the passed labelStyle or default to black
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75),
          borderSide: BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  static Widget buildEmailTextField(TextEditingController emailController) {
    return buildTextField(
      "Email",
      Icons.email,
      emailController,
      validator: validateEmail,
      labelStyle: TextStyle(color: Colors.black),
    );
  }

  static Widget buildOtpTextField(TextEditingController otpController) {
    return buildTextField(
      "OTP",
      Icons.security,
      otpController,
      obscureText: false,
      validator: validateOtp,
      labelStyle: TextStyle(color: Colors.green),
    );
  }

  static Widget buildPasswordTextField(TextEditingController passwordController) {
    return Column(
      children: [
        Container(
          child: buildTextField(
            "Password",
            Icons.lock,
            passwordController,
            obscureText: true,
            validator: validatePassword,
            labelStyle: TextStyle(color: Colors.red), // Change this to the desired color
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }



}

class CustomSnackbar extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const CustomSnackbar({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.0,
      left: 10.0,
      right: 10.0,
      child: Material(
        color: backgroundColor,
        elevation: 10.0,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

class DateIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final Size screenSize = MediaQuery.of(context).size;

    String formattedDate = DateFormat('dd').format(now); // Format the date as 'dd' for day
    String formattedDay = DateFormat('E').format(now); // Format the day as 'E' for day of week

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
    final Size screenSize = MediaQuery
        .of(context)
        .size;
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


class AttendanceRecordWidget extends StatelessWidget {
  final Map<String, dynamic> record;

  const AttendanceRecordWidget({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${record['date']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Checked In: '),
                    Icon(
                      record['isCheckedIn'] ? Icons.check_circle : Icons.cancel,
                      color: record['isCheckedIn'] ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Checked Out: '),
                    Icon(
                      record['isCheckedOut'] ? Icons.check_circle : Icons.cancel,
                      color: record['isCheckedOut'] ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Work From: '),
                Icon(
                  record['isWorkFromHome'] ? Icons.home : Icons.business,
                  color: record['isWorkFromHome'] ? Colors.blue : Colors.orange,
                ),
                SizedBox(width: 5),
                Text(record['isWorkFromHome'] ? 'Home' : 'Office'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
