import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:ui' as ui;
import 'package:ams/constants/appColors.dart';
import 'package:ams/providers/ForgetPassword.dart';
import 'package:ams/components/customWidget.dart';
import 'package:ams/components/Background.dart';
import 'package:ams/screens/login/Login.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  final String email;
  final String otp;

  ResetPasswordScreen({required this.email, required this.otp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isLoading = useState(false);
    final message = useState('');
    final showSnackbar = useState<String?>(null);

    ui.Size size = MediaQuery.of(context).size;

    void showCustomSnackbar(String message) {
      showSnackbar.value = message;
      Future.delayed(Duration(seconds: 3), () {
        showSnackbar.value = null;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Background(
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
                      "Reset Password",
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
                      CustomWidgets.buildPasswordTextField(newPasswordController),
                      SizedBox(height: 24.0),
                      CustomWidgets.buildPasswordTextField(confirmPasswordController),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: isLoading.value
                            ? null
                            : () async {
                          if (newPasswordController.text.isNotEmpty &&
                              confirmPasswordController.text.isNotEmpty &&
                              newPasswordController.text == confirmPasswordController.text) {
                            isLoading.value = true;
                            final response = await ForgetPasswordController.resetPassword(
                              email,
                              otp,
                              newPasswordController.text,
                            );
                            isLoading.value = false;
                            message.value = response ?? 'Failed to reset password';

                            if (response == 'Password reset successfully') {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            } else {
                              showCustomSnackbar('Failed to reset password!');
                            }
                          } else {
                            message.value = 'Passwords do not match';
                            showCustomSnackbar(message.value);
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
                          'Reset Password',
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: showSnackbar.value != null
          ? Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Text(
          showSnackbar.value!,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      )
          : null,
    );
  }
}
