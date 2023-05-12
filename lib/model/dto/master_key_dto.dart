// ignore_for_file: file_names

import 'package:password_manager/export.dart';

class MasterKeyDTO {
  final String uid;
  final String groupId;
  final String masterId;
  final String key;
  final String dateCreated;

  MasterKeyDTO({
    required this.uid,
    required this.groupId,
    required this.masterId,
    required this.key,
    required this.dateCreated,
  });
  // create to map
  Map<String, dynamic> toMap(String masterKey) {
    return {
      'uid': uid,
      'groupId': groupId,
      'masterId': masterId,
      'key': encryptField(key, masterKey),
      'dateCreated': encryptField(dateCreated, masterKey),
    };
  }
}
