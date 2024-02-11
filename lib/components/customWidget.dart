import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class CustomWidgets {
  
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static Widget buildTextField(
      String label, 
      IconData icon, 
      TextEditingController controller,
      {bool obscureText = false,
      Validator? validator,
      }
      ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75),
          borderSide: BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  static Widget buildEmailTextField(TextEditingController emailController) {
    return buildTextField(
      "Email", 
      Icons.email, 
      emailController, 
      validator: validateEmail
      );
  }

  static Widget buildPasswordTextField(TextEditingController passwordController) {
    return Column(
      children: [
        Container(
          child: buildTextField(
            "Password",
            Icons.lock,
            passwordController,
            obscureText: true,
            validator: validatePassword,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle forgot password logic
              print('Forgot Password clicked');
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
