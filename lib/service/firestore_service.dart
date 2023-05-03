import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final firestore = FirebaseFirestore.instance;
// ! Write
  Future<void> registerUser(UserDTO userDTO, BuildContext context) async {
    try {
      return await firestore
          .collection('Users')
          .doc(userDTO.uid)
          .set(userDTO.toMap())
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User registered successfully! ')),
              ));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> createGroupPassword(
      String name, String uid, BuildContext context) async {
    final groupId = const Uuid().v1();
    try {
      return await firestore.collection('Group Passwords').doc(groupId).set({
        'groupId': groupId,
        'uid': uid,
        'groupName': name,
        'dateCreated': DateTime.now().toIso8601String()
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> savePassword(
      bool createGroup,
      String? groupId,
      String generatedPassword,
      String? groupName,
      String uid,
      String description,
      String userName,
      BuildContext context) async {
    try {
      if (createGroup) {
        try {
          final newGroupId = const Uuid().v1();
          await firestore.collection('Group Passwords').doc(newGroupId).set({
            'groupId': newGroupId,
            'uid': uid,
            'groupName': groupName,
            'dateCreated': DateTime.now().toIso8601String()
          }).then((value) => addPassword(
              userName, description, newGroupId, generatedPassword, context));
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } else {
        try {
          await addPassword(
              userName, description, groupId!, generatedPassword, context);
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> addPassword(String userName, String description, String groupId,
      String generatedPassword, BuildContext context) async {
    try {
      final passwordId = const Uuid().v4();
      return await firestore.collection('Passwords').doc(passwordId).set({
        'passwordId': passwordId,
        'userName': userName,
        'description': description,
        'groupId': groupId,
        'password': generatedPassword,
        'dateCreated': DateTime.now().toIso8601String()
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

// ! Read
  Stream<UserModel> getUserData(String uid) {
    return firestore
        .collection('Users')
        .doc(uid)
        .snapshots()
        .map(UserModel.userDataFromSnapshot)
        .handleError((e) {
      print(e);
    });
  }

  // Get stream of group password
  Stream<List<GroupPassword>> getGroupPassword(uid) {
    return firestore
        .collection('Group Passwords')
        .where('uid', isEqualTo: uid)
        .orderBy(
          'groupName',
          descending: false,
        )
        .snapshots()
        .map(
      (snapshot) {
        return GroupPassword.groupPasswordDataFromSnapshot(snapshot);
      },
    ).handleError(
      (e) => print('Group password Error' + e),
    );
  }

  Stream<List<PasswordModel>> viewGroupPassword(groupId) {
    return firestore
        .collection('Passwords')
        .where('groupId', isEqualTo: groupId)
        .orderBy(
          'dateCreated',
          descending: false,
        )
        .snapshots()
        .map(
      (snapshot) {
        return PasswordModel.groupPasswordDataFromSnapshot(snapshot);
      },
    ).handleError(
      (e) => print('Group password Error' + e),
    );
  }
}
