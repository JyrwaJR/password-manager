import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/constant/export_constant.dart';

class PasswordModel {
  final String groupId;
  final String passwordId;
  final String password;
  final String dateCreated;
  final String userName;
  final String website;

  const PasswordModel({
    required this.groupId,
    required this.passwordId,
    required this.password,
    required this.dateCreated,
    required this.userName,
    required this.website,
  });

  static List<PasswordModel> groupPasswordDataFromSnapshot(
      QuerySnapshot snapshot, key, BuildContext context) {
    return snapshot.docs.map((doc) {
      return PasswordModel(
        groupId: doc['groupId'] ?? '',
        passwordId: doc['passwordId'] ?? '',
        password: decryptField(doc['password'], key, context),
        userName: decryptField(doc['userName'], key, context),
        website: decryptField(doc['website'], key, context),
        dateCreated: decryptField(doc['dateCreated'], key, context),
      );
    }).toList();
  }

  static PasswordModel passwordDataFromSnapshotById(
      DocumentSnapshot snapshot, String masterKey, BuildContext context) {
    return PasswordModel(
      groupId: snapshot['groupId'],
      passwordId: snapshot['passwordId'],
      password: decryptField(snapshot['password'], masterKey, context),
      userName: decryptField(snapshot['userName'], masterKey, context),
      website: decryptField(snapshot['website'], masterKey, context),
      dateCreated: decryptField(snapshot['dateCreated'], masterKey, context),
    );
  }
}
