import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPassword {
  final String groupId;
  final String groupName;
  final String dateCreated;
  final String uid;
  GroupPassword({
    required this.groupId,
    required this.groupName,
    required this.dateCreated,
    required this.uid,
  });
  static List<GroupPassword> groupPasswordDataFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return GroupPassword(
        groupId: doc['groupId'] ?? '',
        uid: doc['uid'] ?? '',
        groupName: doc['groupName'] ?? '',
        dateCreated: doc['dateCreated'] ?? '',
      );
    }).toList();
  }
}
