import 'package:cloud_firestore/cloud_firestore.dart';

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
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return GroupPassword(
        groupId: doc['groupId'] ?? '',
        uid: doc['uid'] ?? '',
        groupName: doc['groupName'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
        key: doc['key'] ?? '',
      );
    }).toList();
  }

  static GroupPassword groupPasswordDataFromSnapshotByGroupId(
      DocumentSnapshot snapshot) {
    return GroupPassword(
        groupId: snapshot['groupId'] ?? '',
        groupName: snapshot['groupName'],
        dateCreated: snapshot['groupId'],
        uid: snapshot['groupId'],
        key: snapshot['groupId']);
  }
}
