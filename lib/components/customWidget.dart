import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ams/constants/AppFontsSize.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/models/Team.dart';

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
  final Color selectedItemColor;
  final Color unselectedItemColor;


  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.selectedItemColor = AppColors.buttonColor,
    this.unselectedItemColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
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

class FormElementContainer extends StatelessWidget {
  final Widget child;

  FormElementContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0x3DFF8383),
        borderRadius: BorderRadius.circular(48.0),
      ),
      child: child,
    );
  }
}

class LeaveRequestTile extends StatelessWidget {
  final Map<String, dynamic> leaveRequest;

  LeaveRequestTile({required this.leaveRequest});

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(_getStatusIcon(leaveRequest['status']), color: Colors.amber),
        title: Text(
          '${leaveRequest['leaveType'].toString().toUpperCase()} Leave',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.0),
                SizedBox(width: 4.0),
                Text('Start Date: ${leaveRequest['startDate']}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.0),
                SizedBox(width: 4.0),
                Text('End Date: ${leaveRequest['endDate']}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.note, size: 16.0),
                SizedBox(width: 4.0),
                Expanded(child: Text('Reason: ${leaveRequest['reason']}')),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leaveRequest['status'].toString().toUpperCase(),
              style: TextStyle(
                color: leaveRequest['status'] == 'approved'
                    ? Colors.green
                    : leaveRequest['status'] == 'rejected'
                    ? Colors.red
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
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

class LeaveApprovalTile extends StatelessWidget {
  final Map<String, dynamic> leaveRequest;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  LeaveApprovalTile({
    required this.leaveRequest,
    required this.onApprove,
    required this.onReject,
  });

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(_getStatusIcon(leaveRequest['status']), color: Colors.blue),
        title: Text(
          '${leaveRequest['leaveType'].toString().toUpperCase()} Leave',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 16.0),
                SizedBox(width: 4.0),
                Text('${leaveRequest['firstName']} ${leaveRequest['lastName']}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.badge, size: 16.0),
                SizedBox(width: 4.0),
                Text('Employee ID: ${leaveRequest['employeeId']}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.0),
                SizedBox(width: 4.0),
                Text('Start Date: ${leaveRequest['startDate']}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.0),
                SizedBox(width: 4.0),
                Text('End Date: ${leaveRequest['endDate']}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.note, size: 16.0),
                SizedBox(width: 4.0),
                Expanded(child: Text('Reason: ${leaveRequest['reason']}')),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onApprove,
            ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: onReject,
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveCountsGrid extends StatelessWidget {
  final Map<String, dynamic> leaveCounts;

  LeaveCountsGrid({required this.leaveCounts});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: leaveCounts['remainingLeaves'].entries.map<Widget>((entry) {
        String leaveType = entry.key;
        int remainingLeaves = entry.value;
        return Card(
          margin: EdgeInsets.all(16.0),
          color:Color(0xADFFFFFF) ,
          elevation: 0, // Set elevation to 0 to remove shadow
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1), // Adjust the opacity as needed
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getLeaveIcon(leaveType), size: 40.0, color: Colors.indigo),
                SizedBox(height: 8.0),
                Text(
                  '${leaveType.toUpperCase()}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: 8.0),
                Text(
                  '$remainingLeaves',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.green),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getLeaveIcon(String leaveType) {
    switch (leaveType) {
      case 'medical':
        return Icons.local_hospital;
      case 'casual':
        return Icons.beach_access;
      case 'fullDay':
        return Icons.work;
      case 'halfDay':
        return Icons.access_time;
      default:
        return Icons.calendar_today;
    }
  }
}


class TeamDetailsTile extends StatelessWidget {
  final Team team;

  const TeamDetailsTile({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(

          children: [
            ClipOval(
              child:
            team.teamsImage.isNotEmpty//?Icon(Icons.group, size: 50, color: Colors.indigo)
                ? Image.network(
              team.teamsImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
                : Icon(Icons.group, size: 100, color: Colors.indigo)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.teamName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.work, size: 16),
                      SizedBox(width: 8),
                      Text('Project: ${team.projectName}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.supervisor_account, size: 16),
                      SizedBox(width: 8),
                      Text('Supervisor: ${team.supervisor}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text('Start Date: ${team.startDate}'),
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

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0x3DFF8383),
        borderRadius: BorderRadius.circular(48.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}

