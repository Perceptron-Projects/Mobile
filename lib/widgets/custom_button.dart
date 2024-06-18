import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? boxColor;
  final Color? textColor;
  final Function onPressedCallBack;
  final bool isRequired;
  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressedCallBack,
    this.boxColor,
    this.textColor,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = title.length * 10.0;
    return Container(
      decoration: BoxDecoration(
        color: (boxColor ?? const Color.fromARGB(255, 255, 212, 0)),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize:
              isRequired ? Size(buttonWidth, 50) : const Size.fromHeight(50),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          textStyle: const TextStyle(
            fontFamily: 'lato',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        onPressed: () => onPressedCallBack(),
        child: Text(
          title,
          style: TextStyle(
            color: (textColor ?? const Color.fromARGB(255, 35, 31, 2)),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
