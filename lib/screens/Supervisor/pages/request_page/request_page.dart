import 'package:ams/Animation/animation_controller_mixin.dart';
import 'package:ams/components/hamburger_component/side_overlay.dart';
import 'package:ams/components/user_profile_component/user_profile_component.dart';
import 'package:ams/widgets/button_widget/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  RequestPageState createState() => RequestPageState();
}

class RequestPageState extends State<RequestPage> with SingleTickerProviderStateMixin, AnimationControllerMixin {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Attendance',
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  text: 'Work From Home',
                  onPressed: () {
                    // Handle Mark Attendance
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF04045a),
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  text: 'Mark Attendance',
                  onPressed: () {
                    // Handle History Records
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF193c86),
                ),
              ],
            ),
          ),
          SideOverlay(animation: offsetAnimation),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF8082ab),
        selectedItemColor: const Color(0xFF6cc9e3),
        type: BottomNavigationBarType.fixed,
        iconSize: 3.h,
        unselectedItemColor: Colors.white,
        selectedFontSize: 10.px,
        unselectedFontSize: 10.px,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.house_fill,
              fill: 1,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.chat_bubble_fill,
              fill: 1,
            ),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.bell_fill,
              fill: 1,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person_fill,
              fill: 1,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
