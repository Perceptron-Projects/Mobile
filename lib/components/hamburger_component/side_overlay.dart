import 'package:flutter/material.dart';

class SideOverlay extends StatelessWidget {
  final Animation<Offset> animation;

  SideOverlay({required this.animation});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        width: 250.0,
        height: MediaQuery.of(context).size.height * 0.6, // Reduced height
        color: Colors.grey[200],  // Light grey background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Theme'),
              onTap: () {
                // Add your onTap functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              onTap: () {
                // Add your onTap functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                // Add your onTap functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('FAQ'),
              onTap: () {
                // Add your onTap functionality here
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Add your onTap functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
