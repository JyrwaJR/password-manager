import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/AES/256_bits/256_bits_aes.dart';

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

  static String _decryptField(dynamic value, String key) {
    return value != null ? AES256Bits.decrypt(value, key) : '';
  }

  static List<PasswordModel> groupPasswordDataFromSnapshot(
      QuerySnapshot snapshot, key) {
    return snapshot.docs.map((doc) {
      return PasswordModel(
        groupId: doc['groupId'] ?? '',
        passwordId: doc['passwordId'] ?? '',
        password: _decryptField(doc['password'], key),
        userName: _decryptField(doc['userName'], key),
        website: _decryptField(doc['website'], key),
        dateCreated: _decryptField(doc['dateCreated'], key),
      );
    }).toList();
  }
}
