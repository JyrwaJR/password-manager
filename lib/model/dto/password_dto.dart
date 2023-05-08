import 'package:password_manager/export.dart';

class PasswordDTO {
  final String passwordId;
  final String password;
  final String userName;
  final String website;
  const PasswordDTO({
    required this.passwordId,
    required this.password,
    required this.userName,
    required this.website,
  });
  static String _encryptField(dynamic value, String key) {
    return value != null ? AES256Bits.encrypt(value, key) : '';
  }

  // create to map
  Map<String, dynamic> toMap(String key, String groupId2) {
    return {
      'groupId': groupId2,
      'passwordId': passwordId,
      'password': _encryptField(groupId2, key),
      'userName': _encryptField(userName, key),
      'website': _encryptField(website, key),
      'dateCreated': _encryptField(DateTime.now().toIso8601String(), key),
    };
  }
}
