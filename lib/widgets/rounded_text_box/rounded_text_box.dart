import 'package:flutter/material.dart';

class RoundedTextBox extends StatelessWidget {
  final String label;
  final String initialValue;

  const RoundedTextBox({
    Key? key,
    required this.label,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            initialValue,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
