import 'package:password_manager/export.dart';

class UserDTO {
  String userName;
  String email;
  String uid;

  UserDTO({
    required this.userName,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toMap(String masterKey) {
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
      'key': masterKey,
    };
  }

  // validate
  bool validate() {
    if (userName.isEmpty || email.isEmpty || uid.isEmpty) {
      return false;
    }
    if (userName.length < 3 || userName.length > 20) {
      return false;
    }
    if (!EmailValidator.validate(email) == false) {
      return false;
    }
    return true;
  }
}
