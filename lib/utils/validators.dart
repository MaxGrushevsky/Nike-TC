import 'password_strength.dart';

class Validators {
  static final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  static String? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter a valid email address.';
    if (trimmed.length > 255) return 'Email must be 255 characters or less.';
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? loginPassword(String value) {
    if (value.isEmpty) return 'Please enter a password.';
    if (value.length > 255) return 'Password must be 255 characters or less.';
    return null;
  }

  static String? joinPassword(String value) {
    if (value.isEmpty) return 'Please enter a password.';
    if (value.length > 255) return 'Password must be 255 characters or less.';
    if (!PasswordStrength.meetsMinimum(value)) {
      return 'Password does not meet minimum requirements.';
    }
    return null;
  }

  static String? firstName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter a valid first name.';
    if (trimmed.length > 255) {
      return 'First name must be 255 characters or less.';
    }
    return null;
  }

  static String? lastName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter a valid last name.';
    if (trimmed.length > 255) {
      return 'Last name must be 255 characters or less.';
    }
    return null;
  }

  static String? dateOfBirth(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter a valid date of birth.';
    if (trimmed.length > 255) return 'Date must be 255 characters or less.';
    return null;
  }
}
