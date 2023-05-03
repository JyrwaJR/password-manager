import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/model/model/group_password.dart';

class PasswordModel {
  final String groupId;
  final String passwordId;
  final String password;
  final String dateCreated;
  final String userName;
  final String? description;
  const PasswordModel({
    required this.groupId,
    required this.passwordId,
    required this.password,
    required this.dateCreated,
    required this.userName,
    this.description,
    // required this.masterKeyId,
  });

  static List<PasswordModel> groupPasswordDataFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PasswordModel(
        groupId: doc['groupId'] ?? '',
        password: doc['password'] ?? '',
        passwordId: doc['passwordId'] ?? '',
        userName: doc['userName'] ?? '',
        description: doc['description'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
      );
    }).toList();
  }
}
