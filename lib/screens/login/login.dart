import 'package:flutter/material.dart';
import 'package:ams/components/background.dart';
import 'package:ams/components/customWidget.dart';
import 'package:ams/constants/appColors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ams/providers/AuthController.dart';
import 'dart:ui' as ui;
import 'package:ams/screens/home/Home.dart';
import 'package:ams/screens/attendance/MarkAttendance.dart';
import 'package:ams/screens/forgetPassword/ForgetPassword.dart';

final authControllerProvider = Provider((ref) => AuthController());

class LoginScreen extends HookConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> isLoading = useState(false);

    ui.Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                      child: Image.asset(
                        'assets/images/icon/companyLogo.png',
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidgets.buildEmailTextField(emailController),
                          SizedBox(height: 24.0),
                          CustomWidgets.buildPasswordTextField(passwordController),
                          Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: isLoading.value ? null : () async {
                              final email = emailController.text;
                              final password = passwordController.text;

                              isLoading.value = true;

                              try {
                                await ref.read(authControllerProvider).signIn(email, password);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomePageScreen()),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid Email or Password!")),
                                );
                              } finally {
                                isLoading.value = false;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              backgroundColor: AppColors.buttonColor,
                              fixedSize: Size(size.width * 0.3, size.width * 0.125),
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
                              'Sign In',
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
