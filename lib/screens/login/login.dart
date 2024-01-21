import 'package:flutter/material.dart';
import 'package:ams/components/background.dart';
import 'package:ams/components/customWidget.dart';
import 'package:ams/constants/appColors.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        "SyncIn",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          fontSize: 48,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidgets.buildTextField(
                            "Email",
                            Icons.email,
                            emailController,
                          ),
                          SizedBox(height: 24.0),
                          CustomWidgets.buildPasswordTextField(passwordController),
                          SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: () {
                              print(
                                'Email: ${emailController.text}, Password: ${passwordController.text}',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              backgroundColor: AppColors.buttonColor,
                              fixedSize: Size(size.width * 0.3, size.width * 0.125),
                            ),
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.04,
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
