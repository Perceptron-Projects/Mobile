
abstract class CustomFunction {
  static bool isValidName(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isNotEmpty;
  }

  static bool isValidPassword(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isNotEmpty;
  }

  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
  
}
