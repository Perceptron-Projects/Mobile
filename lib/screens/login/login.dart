import 'package:ams/Bloc/Auth_Bloc/auth_bloc.dart';
import 'package:ams/components/background.dart';
import 'package:ams/components/customWidget.dart';
import 'package:ams/constants/appColors.dart';
import 'package:ams/constants/user_role.dart';
import 'package:ams/resource/Provider/provider.dart';
import 'package:ams/screens/Home/home_screen.dart';
import 'package:ams/util/custom_function.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthBloc authBloc;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void signIn() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!CustomFunction.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (!CustomFunction.isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid password.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, String> formData = {'email': email, 'password': password};

    authBloc.login(formData).then((user) {
      setState(() {
        isLoading = false;
      });
      authBloc.setToken(user.token);
      authBloc.setCompanyId(user.companyId);
      authBloc.setUserId(user.userId);
      authBloc.setUserRole(
        user.role[0] == 'supervisor'
            ? UserRole.supervisor
            : user.role[0] == 'employee'
                ? UserRole.employee
                : UserRole.hr,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  userRole: authBloc.getUserRole(),
                )),
      );
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: ${error.message}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    authBloc = Provider.of(context).authBloc;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Background(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32.0),
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                        const SizedBox(height: 32.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomWidgets.buildTextField(
                              "Email",
                              Icons.email,
                              emailController,
                            ),
                            const SizedBox(height: 24.0),
                            CustomWidgets.buildPasswordTextField(
                                passwordController),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                              onPressed: isLoading ? null : signIn,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                                backgroundColor: AppColors.buttonColor,
                                fixedSize:
                                    Size(size.width * 0.3, size.width * 0.125),
                              ),
                              child: !isLoading
                                  ? Text(
                                      'Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.04,
                                        color: AppColors.textColor,
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(),
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
        ),
      ),
    );
  }
}
