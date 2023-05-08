import 'package:password_manager/AES/256_bits/256_bits_aes.dart';

class GroupPasswordDTO {
  final String groupId;
  final String groupName;
  final String dateCreated;
  final String uid;
  final String key;
  GroupPasswordDTO({
    required this.groupId,
    required this.groupName,
    required this.dateCreated,
    required this.uid,
    required this.key,
  });
  static String _encryptField(dynamic value, String key) {
    return value != null ? AES256Bits.encrypt(value, key) : '';
  }

  Map<String, dynamic> toMap(String masterKey) {
    return {
      'groupId': groupId,
      'uid': uid,
      'groupName': _encryptField(groupName, masterKey),
      'dateCreated': _encryptField(dateCreated, masterKey),
      'key': _encryptField(key, masterKey),
      'key2': key,
    };
  }
}
