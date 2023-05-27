import 'package:cloud_firestore/cloud_firestore.dart';
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
      QuerySnapshot snapshot, key) {
    return snapshot.docs.map((doc) {
      return PasswordModel(
        groupId: doc['groupId'] ?? '',
        passwordId: doc['passwordId'] ?? '',
        password: decryptField(doc['password'], key),
        userName: decryptField(doc['userName'], key),
        website: decryptField(doc['website'], key),
        dateCreated: decryptField(doc['dateCreated'], key),
      );
    }).toList();
  }

  static PasswordModel passwordDataFromSnapshotById(
      DocumentSnapshot snapshot, String masterKey) {
    return PasswordModel(
      groupId: snapshot['groupId'],
      passwordId: snapshot['passwordId'],
      password: decryptField(snapshot['password'], masterKey),
      userName: decryptField(snapshot['userName'], masterKey),
      website: decryptField(snapshot['website'], masterKey),
      dateCreated: decryptField(snapshot['dateCreated'], masterKey),
    );
  }
}
