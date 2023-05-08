
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

  Map<String, dynamic> toMap() {
    final masterKey = MasterKeyGenerator.generateKey();
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
      'key': masterKey,
    };
  }
}
