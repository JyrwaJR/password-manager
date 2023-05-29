import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class GroupPassword {
  final String groupId;
  final String groupName;
  final String dateCreated;
  final String uid;
  final String key;
  GroupPassword({
    required this.groupId,
    required this.groupName,
    required this.dateCreated,
    required this.uid,
    required this.key,
  });

  static List<GroupPassword> groupPasswordDataFromSnapshot(
      QuerySnapshot snapshot, String masterKey, BuildContext context) {
    return snapshot.docs.map((doc) {
      return GroupPassword(
        groupId: doc['groupId'] ?? '',
        uid: doc['uid'] ?? '',
        groupName: decryptField(doc['groupName'], masterKey, context),
        dateCreated: decryptField(doc['dateCreated'], masterKey, context),
        key: decryptField(doc['key'], masterKey, context),
      );
    }).toList();
  }

  static GroupPassword groupPasswordDataFromSnapshotByGroupId(
      DocumentSnapshot snapshot, String masterKey, BuildContext context) {
    if (!snapshot.exists) {
      return GroupPassword(
          groupId: '',
          groupName: '',
          dateCreated: '',
          uid: '',
          key: ''); // or throw an exception, depending on your needs
    }
    return GroupPassword(
      groupId: snapshot['groupId'] ?? '',
      uid: snapshot['uid'] ?? '',
      groupName: decryptField(snapshot['groupName'], masterKey, context),
      dateCreated: decryptField(snapshot['dateCreated'], masterKey, context),
      key: decryptField(snapshot['key'], masterKey, context),
    );
  }

  static fromMap(dynamic data) {
    return GroupPassword(
      groupId: data!['groupId'] ?? '',
      uid: data['uid'] ?? '',
      groupName: data['groupName'] ?? '',
      dateCreated: data['dateCreated'] ?? '',
      key: data['key'] ?? '',
    );
  }
}
