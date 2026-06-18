import 'package:zxcvbn/zxcvbn.dart';

class PasswordStrength {
  PasswordStrength._();

  static final Zxcvbn _zxcvbn = Zxcvbn();

  static const int minimumAcceptableScore = 2;

  static int score(String password) {
    if (password.isEmpty) return 0;
    final result = _zxcvbn.evaluate(password);
    final raw = result.score ?? 0;
    return raw.round().clamp(0, 4);
  }

  static String label(int scoreValue) {
    switch (scoreValue.clamp(0, 4)) {
      case 0:
        return 'Too guessable';
      case 1:
        return 'Very guessable';
      case 2:
        return 'Somewhat guessable';
      case 3:
        return 'Safely unguessable';
      case 4:
        return 'Very unguessable';
      default:
        return '';
    }
  }

  static bool meetsMinimum(String password) {
    return score(password) >= minimumAcceptableScore;
  }
}
