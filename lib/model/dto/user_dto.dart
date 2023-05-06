import 'package:password_manager/export.dart';

class UserDTO {
  String userName;
  String email;
  String uid;
  String masterKey;
  UserDTO({
    required this.userName,
    required this.email,
    required this.uid,
    required this.masterKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'email': email,
      'uid': uid,
      'masterKey': AES256Bits.encrypt(masterKey, uid),
    };
  }
}
