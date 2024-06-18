import 'package:ams/resource/Provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ams/screens/welcome/Welcome.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const AMSAPP());
}

class AMSAPP extends StatelessWidget {
  const AMSAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Provider(
          child: MaterialApp(
            title: 'AMS App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF2661FA),
              scaffoldBackgroundColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const WelcomeScreen(),
          ),
        );
      },
      maxTabletWidth: 900,
    );
  }
}
