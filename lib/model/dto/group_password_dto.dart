import 'package:password_manager/export.dart';

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

  Map<String, dynamic> toMap(String masterKey) {
    return {
      'groupId': groupId,
      'uid': uid,
      'groupName': encryptField(groupName, masterKey),
      'dateCreated': encryptField(dateCreated, masterKey),
      'key': encryptField(key, masterKey),
    };
  }
}
