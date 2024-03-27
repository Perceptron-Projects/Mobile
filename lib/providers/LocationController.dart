import 'package:flutter/material.dart';
import 'package:ams/constants/AppColors.dart';
import 'package:ams/constants/AppFontsSize.dart';

class LocationSelection extends StatefulWidget {
  @override
  LocationSelectionState createState() => LocationSelectionState();
}

class LocationSelectionState extends State<LocationSelection> {
  String selectedLocation = 'Office'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio<String>(
          value: 'Office',
          groupValue: selectedLocation,
          onChanged: (value) {
            setState(() {
              selectedLocation = value!;
            });
          },
          activeColor: Colors.green, // Change color when selected
        ),
        Text('Office',
            style: TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: appFontsSize.bodyFontSize,
                fontWeight: FontWeight.bold)),
        SizedBox(width: 20),
        Radio<String>(
          value: 'Home',
          groupValue: selectedLocation,
          onChanged: (value) {
            setState(() {
              selectedLocation = value!;
            });
          },
          activeColor: Colors.green, // Change color when selected
        ),
        Text('Home',
            style: TextStyle(
                color: AppColors.primaryTextColor,
                fontSize: appFontsSize.bodyFontSize,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}
