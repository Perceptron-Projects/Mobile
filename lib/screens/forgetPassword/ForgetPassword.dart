import 'package:flutter/material.dart';
import 'package:ams/components/background.dart';
import 'package:ams/constants/appColors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;
import 'package:ams/providers/ForgetPassword.dart';
import 'package:ams/components/customWidget.dart';
import 'package:ams/screens/forgetPassword/ResetPassword.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure hooks are called inside the build method
    final emailController = useTextEditingController();
    final otpController = useTextEditingController();
    final isLoading = useState(false);
    final message = useState('');

    ui.Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Forget Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: AppColors.primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ),
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 32.0),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        "Verify User",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomWidgets.buildEmailTextField(emailController),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: isLoading.value
                              ? null
                              : () async {
                            if (emailController.text.isNotEmpty) {
                              isLoading.value = true;
                              final response = await ForgetPasswordController.sendOtp(emailController.text);
                              message.value = response ?? 'Failed to send OTP';
                              isLoading.value = false;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            backgroundColor: AppColors.buttonColor,
                            fixedSize: ui.Size(size.width * 0.6, size.width * 0.125),
                          ),
                          child: isLoading.value
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor),
                            ),
                          )
                              : const Text(
                            'Send OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        Text(
                          message.value,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.0),
                        CustomWidgets.buildOtpTextField(otpController),
                        SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: isLoading.value
                              ? null
                              : () async {
                            if (otpController.text.isNotEmpty) {
                              isLoading.value = true;
                              final response = await ForgetPasswordController.compareOtp(
                                  emailController.text, otpController.text);
                              message.value = response ?? 'Failed to verify OTP';
                              isLoading.value = false;
                              if (response == 'OTP verified successfully') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen(
                                      email: emailController.text,
                                      otp: otpController.text,
                                    ),
                                  ),
                                );
                              } else {
                                message.value = response ?? 'Failed to verify OTP';
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(message.value),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                            backgroundColor: AppColors.buttonColor,
                            fixedSize: ui.Size(size.width * 0.6, size.width * 0.125),
                          ),
                          child: isLoading.value
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor),
                            ),
                          )
                              : const Text(
                            'Verify OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
