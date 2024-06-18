import 'package:flutter/material.dart';

class CustomWidgets {
  static Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool obscureText = false}) {
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
          borderSide: const BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(75),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
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
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle forgot password logic
              print('Forgot Password clicked');
            },
            child: const Text(
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
