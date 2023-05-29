import 'package:flutter/material.dart';
import 'package:password_manager/constant/export_constant.dart';

class NotesGroupDTO {
  final String groupId;
  final String groupName;
  final String dateCreated;
  final String uid;
  final String key;

  NotesGroupDTO({
    required this.groupId,
    required this.groupName,
    required this.dateCreated,
    required this.uid,
    required this.key,
  });

  // to map
  Map<String, dynamic> toMap(masterKey, BuildContext context) {
    return {
      'groupId': groupId,
      'uid': uid,
      'groupName': encryptField(groupName, masterKey, context),
      'dateCreated': encryptField(dateCreated, masterKey, context),
      'key': encryptField(key, masterKey, context),
    };
  }
}
