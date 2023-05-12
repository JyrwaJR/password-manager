class EmailValidator {
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static bool validate(String value) {
    if (value.isEmpty) {
      return false;
    }
    if (!EmailValidator()._emailRegExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
