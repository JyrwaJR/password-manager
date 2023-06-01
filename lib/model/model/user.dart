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

  static UserModel? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return UserModel(
      userName: map['userName'],
      email: map['email'],
      uid: map['uid'],
      key: map['key'],
    );
  }
}
