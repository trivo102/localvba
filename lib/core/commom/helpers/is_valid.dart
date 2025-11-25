class Validators {
  /// Regular expression for validating email addresses.
  /// - Ensures the email follows standard email format.
  /// - Allows letters, numbers, and special characters before the `@` symbol.
  /// - Ensures a valid domain format after `@`
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  /// Regular expression for validating passwords.
  /// - Ensures password length is between **4 to 8 characters**.
  static final RegExp _passwordRegExp = RegExp(r'^.{4,8}$');

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidName(String name) {
    return name.isNotEmpty;
  }
}