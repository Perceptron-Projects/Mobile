import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StatsRow extends StatelessWidget {
  final String label;
  final int value;
  final int maValue;
  final Color valueColor;
  final Color inactiveColor;

  const StatsRow({
    Key? key,
    required this.label,
    required this.value,
    required this.maValue,
    this.valueColor = Colors.blue,
    this.inactiveColor = const Color.fromRGBO(224, 224, 224, 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          LinearProgressIndicator(
            value: value / 10,
            backgroundColor: inactiveColor,
            valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          ),
          SizedBox(
            height: 1.h,
          ),
          Container(
            height: 7.h,
            child: TextField(
              controller: TextEditingController(text: '$value'),
              textAlign: TextAlign.left,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16.sp,
              ),
              readOnly: true, // Make it non-editable
            ),
          ),
        ],
      ),
    );
  }
}
