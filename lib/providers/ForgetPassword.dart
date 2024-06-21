import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ams/api/ApiClient.dart';

class ForgetPasswordController {
  static const String _baseUrl = '${ApiClient.baseUrl}/api/users';

  static Future<String?> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forget-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return 'OTP sent successfully';
    } else {
      return 'Failed to send OTP';
    }
  }

  static Future<String?> compareOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/compare-otp'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return 'OTP verified successfully';
    } else {
      return 'Invalid OTP';
    }
  }

  static Future<String?> resetPassword(String email, String otp, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reset-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return 'Password reset successfully';
    } else {
      return 'Failed to reset password';
    }
  }
}
