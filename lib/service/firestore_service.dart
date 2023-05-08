import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final firestore = FirebaseFirestore.instance;

// ! Write
  Future<void> registerUser(UserDTO userDTO, BuildContext context) async {
    try {
      await firestore
          .collection('Users')
          .doc(userDTO.uid)
          .set(userDTO.toMap())
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User registered successfully!')),
              ));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> addMasterKey(
      String uid, String groupId, BuildContext context) async {
    final masterId = const Uuid().v1();
    final data = await firestore
        .collection("Master Keys")
        .where('uid', isEqualTo: uid)
        .get();
    if (data.docs.isEmpty) {
      final result = await firestore.collection("Users").doc(uid).get();
      if (result.data()?['key'] != null) {
        final key = result.data()?['key'];
        final masterkey = MasterKeyGenerator.generateKey();
        final encryptKey = AES256Bits.encrypt(masterkey, key);
        await firestore.collection('Master Keys').doc(masterId).set({
          'masterId': masterId,
          'uid': uid,
          'groupId': groupId,
          'key': encryptKey,
          'dateCreated': DateTime.now().toIso8601String(),
        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Master key generated'))));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Master key already Generated')));
    }
  }

  Future<String?> createGroupForPassword(
      String groupName, String uid, BuildContext context) async {
    try {
      final userKey = await getUserKey(uid, context);
      if (userKey != null) {
        final groupId = const Uuid().v1();
        final masterId = const Uuid().v1();
        final masterKey = MasterKeyGenerator.generateKey();
        await firestore.collection('Master Keys').doc(masterId).set({
          'masterId': masterId,
          'groupId': groupId,
          'dateCreated': DateTime.now().toIso8601String(),
          'uid': uid,
          'key': AES256Bits.encrypt(masterKey, userKey),
          'key-decrypt': masterKey,
        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group created successfully'))));
        // ! Group
        final groupKey = MasterKeyGenerator.generateKey();
        await firestore.collection('Group Passwords').doc(groupId).set({
          'groupId': groupId,
          'groupName': groupName,
          'dateCreated': DateTime.now().toIso8601String(),
          'uid': uid,
          'key': AES256Bits.encrypt(groupKey, masterKey),
          'key-Decrypt': groupKey,
        }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group created successfully'))));
        return groupId;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  Future<void> addPassword(
    PasswordDTO passwordDTO,
    String groupId,
    String uid,
    BuildContext context,
  ) async {
    try {
      final key = await getGroupKey(groupId, uid, context);

      if (key != null) {
        await firestore.collection('Passwords').doc(passwordDTO.passwordId).set(
              passwordDTO.toMap(key, groupId),
            );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Please try again')));
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

// ! Read
  Future<String?> getGroupKey(
      String groupId, String uid, BuildContext context) async {
    try {
      final masterKey = await getMasterKey(uid, groupId, context);
      if (masterKey != null) {
        final groupData =
            await firestore.collection('Group Passwords').doc(groupId).get();
        if (groupData.data()?['key'] != null) {
          final encryptedKey = groupData.data()?['key'];
          final groupKey = AES256Bits.decrypt(encryptedKey, masterKey);
          return groupKey;
        } else {
          return null;
        }
      }
      return null;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  Future<String?> getMasterKey(
      String uid, String groupId, BuildContext context) async {
    try {
      final userKey = await getUserKey(uid, context);
      final result = await firestore
          .collection("Master Keys")
          .where('groupId', isEqualTo: groupId)
          .get();
      if (result.docs.isNotEmpty) {
        final encryptedKey = result.docs[0].data()['key'];
        final masterKey = AES256Bits.decrypt(encryptedKey, userKey!);
        return masterKey;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return null;
    }
  }

  Future<String?> getUserKey(String uid, BuildContext context) async {
    try {
      final result = await firestore
          .collection("Users")
          .where('uid', isEqualTo: uid)
          .get();
      if (result.docs.isNotEmpty) {
        final masterKey = result.docs[0].data()['key'];
        return masterKey;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User key not found'),
        ));
        return null;
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return null;
    }
  }

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

  Stream<GroupPassword> getGroupPasswordWithGroupId(String groupId) {
    return firestore.collection('Group Passwords').doc(groupId).snapshots().map(
      (snapshot) {
        return GroupPassword.groupPasswordDataFromSnapshotByGroupId(snapshot);
      },
    ).handleError(
      (e) => print('Group password Error' + e),
    );
  }

  // Stream<List<PasswordModel>> viewGroupPassword(
  //     String groupId, BuildContext context) {
  //  return firestore
  //    .collection('Passwords')
  //  .where('groupId', isEqualTo: groupId)
  //.snapshots()
  //.map(
  //(snapshot) {///
  //return PasswordModel.groupPasswordDataFromSnapshot(snapshot);
  //},
  //).handleError((e) => ScaffoldMessenger.of(context)
  //      .showSnackBar(SnackBar(content: Text(e.toString()))));
  //}
  Stream<List<PasswordModel>> viewGroupPasswordWithKey(
      String groupId, String uid, BuildContext context) {
    return FirebaseFirestore.instance
        .collection('Passwords')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .asyncMap((snapshot) async {
          final groupKey = await getGroupKey(groupId, uid, context);
          if (groupKey == null) {
            return [];
          }
          return PasswordModel.groupPasswordDataFromSnapshot(
              snapshot, groupKey);
        })
        .handleError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString()))))
        .cast<List<PasswordModel>>();
  }

  // ! Update
  // ! Update Group Name
  Future<void> updateGroupName(
      String groupId, String groupName, BuildContext context) async {
    try {
      return await firestore.collection('Group Passwords').doc(groupId).update({
        'groupName': groupName,
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ! Delete
  // ! Delete password with group
  // delete password which contain groupId
  Future<void> deleteGroupPassword(String groupId, BuildContext context) async {
    try {
      return await firestore
          .collection('Passwords')
          .where('groupId', isEqualTo: groupId)
          .get()
          .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.delete();
            }
            // then delete group password
          })
          .then((value) => firestore
                  .collection('Master Keys')
                  .where('groupId', isEqualTo: groupId)
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              }))
          .then((value) =>
              firestore.collection('Group Passwords').doc(groupId).delete());
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
