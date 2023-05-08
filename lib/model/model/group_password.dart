import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_manager/AES/256_bits/256_bits_aes.dart';

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

  static String _decryptField(dynamic value, String key) {
    return value != null ? AES256Bits.decrypt(value, key) : '';
  }

  static List<GroupPassword> groupPasswordDataFromSnapshot(
      QuerySnapshot snapshot, String masterKey) {
    return snapshot.docs.map((doc) {
      return GroupPassword(
        groupId: doc['groupId'] ?? '',
        uid: doc['uid'] ?? '',
        groupName: AES256Bits.decrypt(doc['groupName'], masterKey),
        dateCreated: AES256Bits.decrypt(doc['dateCreated'], masterKey),
        key: AES256Bits.decrypt(doc['key'], masterKey),
      );
    }).toList();
  }

  static GroupPassword groupPasswordDataFromSnapshotByGroupId(
      DocumentSnapshot snapshot, String masterKey) {
    return GroupPassword(
      groupId: snapshot['groupId'] ?? '',
      uid: snapshot['uid'] ?? '',
      groupName: _decryptField(snapshot['groupName'], masterKey),
      dateCreated: _decryptField(snapshot['dateCreated'], masterKey),
      key: _decryptField(snapshot['key'], masterKey),
    );
  }
}
