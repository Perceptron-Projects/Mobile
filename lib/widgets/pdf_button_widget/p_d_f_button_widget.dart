// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PDFButtonWidget extends StatelessWidget {
  final void Function()? onPressed;

  const PDFButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
        vertical: 1.h,
      ),
      constraints: BoxConstraints(
        maxWidth: 50.w,
      ),
      width: 40.w,
      child: ElevatedButton(
        onPressed: () {
          // Handle PDF generation here
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PDF',
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              width: 1.w,
            ),
            Icon(
              Icons.save_alt,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
