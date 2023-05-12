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

  // create to map
  Map<String, dynamic> toMap(String key, String groupId2) {
    return {
      'groupId': groupId2,
      'passwordId': passwordId,
      'password': encryptField(groupId2, key),
      'userName': encryptField(userName, key),
      'website': encryptField(website, key),
      'dateCreated': encryptField(DateTime.now().toIso8601String(), key),
    };
  }
}
