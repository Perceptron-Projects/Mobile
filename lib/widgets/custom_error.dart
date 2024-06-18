import 'package:ams/constants/appColors.dart';
import 'package:ams/widgets/custom_button.dart';
import 'package:ams/widgets/custom_loading_button.dart';
import 'package:flutter/material.dart';


class CustomError extends StatefulWidget {
  final Function callBack;
  final String errorMsg;

  const CustomError({Key? key, required this.callBack, required this.errorMsg})
      : super(key: key);

  @override
  State<CustomError> createState() => _CustomErrorState();
}

class _CustomErrorState extends State<CustomError> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        // border: Border.all(
        //   color: const Color(0xFFAAAAAA),
        //   width: 1,
        // ),
        // borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      // height: 125,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ERROR',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: AppColors.textWarning,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.errorMsg,
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: AppColors.textWarning,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    height: 48,
                    width: 170,
                    child: CustomLoadingButton(),
                  )
                : SizedBox(
                    height: 48,
                    width: 190,
                    child: CustomButton(
                      title: 'Try again',
                      onPressedCallBack: _handleRetry,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  _handleRetry() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      widget.callBack();
      setState(() {
        isLoading = false;
      });
    });
  }
}
