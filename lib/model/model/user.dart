import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userName;
  String email;
  String uid;
  String key;

  static UserModel userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      userName: snapshot['userName'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      key: snapshot['key'],
    );
  }

  UserModel({
    required this.userName,
    required this.email,
    required this.uid,
    required this.key,
  });
}
