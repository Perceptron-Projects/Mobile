import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CheckInOutWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const CheckInOutWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 7.w,
          vertical: 1.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "EID:",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "${data["EID"] == null || data["EID"] == '' ? "_ _ _ _ _ _ _" : data["EID"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "First Check in:",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "${data["EID"] == null || data["EID"] == '' ? "_ _ _ _ _ _ _" : data["EID"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "First Check out:",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "${data["EID"] == null || data["EID"] == '' ? "_ _ _ _ _ _ _" : data["EID"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Date:",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "${data["EID"] == null || data["EID"] == '' ? "_ _ _ _ _ _ _" : data["EID"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Last Check in:",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "${data["EID"] == null || data["EID"] == '' ? "_ _ _ _ _ _ _" : data["EID"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "Last Check out:",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "${data["EID"] == null || data["EID"] == '' ? "_ _ _ _ _ _ _" : data["EID"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
