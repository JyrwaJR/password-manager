import 'package:cloud_firestore/cloud_firestore.dart';

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
    // required this.masterKeyId,
  });

  static List<PasswordModel> groupPasswordDataFromSnapshot(
    QuerySnapshot snapshot,
  ) {
    return snapshot.docs.map((doc) {
      return PasswordModel(
        groupId: doc['groupId'] ?? '',
        password: doc['password'] ?? '',
        passwordId: doc['passwordId'] ?? '',
        userName: doc['userName'] ?? '',
        website: doc['website'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
      );
    }).toList();
  }
}
