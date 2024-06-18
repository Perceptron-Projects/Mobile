import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle? textStyle;
  final Color? textColor;
  final double borderRadius;
  final double elevation;
  final double? padding;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
    this.width,
    this.height,
    this.textStyle,
    this.textColor,
    this.borderRadius = 10,
    this.elevation = 0,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 50.w,
      height: height ?? 10.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: backgroundColor, // Button color
          foregroundColor: foregroundColor, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 2.h,
          ),
        ),
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize ?? 16.px,
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
