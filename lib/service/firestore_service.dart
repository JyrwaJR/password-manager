// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/model/dto/notes_group_dto.dart';
import 'package:password_manager/model/model/notes_group.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  static final firestore = FirebaseFirestore.instance;
  final CollectionReference _UsersCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _GroupPasswordsCollection =
      FirebaseFirestore.instance.collection('Group Passwords');
  final CollectionReference _PasswordsCollection =
      FirebaseFirestore.instance.collection('Passwords');
  final CollectionReference _MasterKeysCollection =
      FirebaseFirestore.instance.collection('Master Keys');
  final CollectionReference _NotesGroupCollection =
      FirebaseFirestore.instance.collection('Notes Group');
  final CollectionReference _NotesCollection =
      FirebaseFirestore.instance.collection('Notes');

// ! Write
  Future<void> registerUser(UserDTO userDTO, BuildContext context) async {
    if (userDTO.validate()) {
      try {
        final masterKey = MasterKeyGenerator.generateKey();
        await _UsersCollection.doc(userDTO.uid)
            .set(userDTO.toMap(masterKey))
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('User registered successfully!')),
                ));
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid Data')));
    }
  }

  Future<void> addMasterKey(
      String uid, String groupId, BuildContext context) async {
    final masterId = const Uuid().v1();
    final data = await _MasterKeysCollection.where('uid', isEqualTo: uid).get();
    if (data.docs.isEmpty) {
      final key = await getUserKey(uid, context);
      if (key != null) {
        final masterKey = MasterKeyGenerator.generateKey();
        final masterKeyDto = MasterKeyDTO(
            uid: uid,
            groupId: groupId,
            masterId: masterId,
            key: masterKey,
            dateCreated: DateTime.now().toIso8601String());
        await firestore
            .collection('Master Keys')
            .doc(masterId)
            .set(masterKeyDto.toMap(key))
            .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Master key generated'))));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Master key already Generated')));
    }
  }

  Future<String?> createGroupForPassword(
    String groupName,
    String uid,
    BuildContext context,
  ) async {
    final userKey = await getUserKey(uid, context);
    if (userKey == null) {
      return null;
    }

    final listOfGroups = await _GroupPasswordsCollection.get();
    final groups = listOfGroups.docs;

    if (groups.isNotEmpty) {
      for (final group in groups) {
        final masterKey = await getMasterKey(uid, group['groupId'], context);
        if (masterKey != null) {
          final eGroupName = decryptField(group['groupName'], masterKey);
          if (eGroupName.toLowerCase() == groupName.toLowerCase()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Group name already exists')),
            );
            final id = group['groupId'];
            return id;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Error retrieving group master key. Please try again')),
          );
          return null;
        }
      }
    }

    final groupId = await createGroup(groupName, uid, context);
    return groupId;
  }

  Future<String?> createGroupForNote(
    String groupName,
    String uid,
    BuildContext context,
  ) async {
    final userKey = await getUserKey(uid, context);
    if (userKey == null) {
      return null;
    }

    final listOfGroups = await _NotesGroupCollection.get();
    final groups = listOfGroups.docs;

    if (groups.isNotEmpty) {
      for (final group in groups) {
        final masterKey = await getMasterKey(uid, group['groupId'], context);
        if (masterKey != null) {
          final eGroupName = decryptField(group['groupName'], masterKey);
          if (eGroupName.toLowerCase() == groupName.toLowerCase()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Group name already exists')),
            );
            final id = group['groupId'];
            return id;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Error retrieving group master key. Please try again')),
          );
          return null;
        }
      }
    }

    final groupId = await createNotesGroup(groupName, uid, context);
    return groupId;
  }

  Future<String?> createGroup(
      String groupName, String uid, BuildContext context) async {
    try {
      final userKey = await getUserKey(uid, context);
      if (userKey != null) {
        final groupId = const Uuid().v1();
        final masterId = const Uuid().v1();
        final masterKey = MasterKeyGenerator.generateKey();
        // ! Master
        final masterKeyDto = MasterKeyDTO(
            uid: uid,
            groupId: groupId,
            masterId: masterId,
            key: masterKey,
            dateCreated: DateTime.now().toIso8601String());
        await _MasterKeysCollection.doc(masterId)
            .set(masterKeyDto.toMap(userKey));
        // ! Group
        final groupKey = MasterKeyGenerator.generateKey();
        final groupPasswordDTO = GroupPasswordDTO(
            groupId: groupId,
            groupName: groupName,
            dateCreated: DateTime.now().toIso8601String(),
            uid: uid,
            key: groupKey);
        await _GroupPasswordsCollection.doc(groupId)
            .set(groupPasswordDTO.toMap(masterKey))
            .then((value) => context.goNamed('view group password',
                queryParameters: <String, String>{'groupId': groupId}));
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

  Future<String?> createNotesGroup(
    String groupName,
    String uid,
    BuildContext context,
  ) async {
    try {
      final userKey = await getUserKey(uid, context);
      if (userKey != null) {
        final groupId = const Uuid().v1();
        final masterId = const Uuid().v1();
        final masterKey = MasterKeyGenerator.generateKey();
        // ! Master
        final masterKeyDto = MasterKeyDTO(
            uid: uid,
            groupId: groupId,
            masterId: masterId,
            key: masterKey,
            dateCreated: DateTime.now().toIso8601String());
        await _MasterKeysCollection.doc(masterId)
            .set(masterKeyDto.toMap(userKey));
        // ! Group
        final groupKey = MasterKeyGenerator.generateKey();
        final noteGroupDTO = NotesGroupDTO(
          groupId: groupId,
          groupName: groupName,
          dateCreated: DateTime.now().toIso8601String(),
          uid: uid,
          key: groupKey,
        );
        await _NotesGroupCollection.doc(groupId)
            .set(noteGroupDTO.toMap(masterKey));
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
        await _PasswordsCollection.doc(passwordDTO.passwordId)
            .set(
              passwordDTO.toMap(key, groupId),
            )
            .then((value) => context.goNamed('view group password',
                queryParameters: <String, String>{'groupId': groupId}))
            .then((value) => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Password added'))));
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

  Stream<UserModel> getUserData(String uid, BuildContext context) {
    return _UsersCollection.doc(uid)
        .snapshots()
        .map(UserModel.userDataFromSnapshot)
        .handleError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

// Get stream of password with password id
  Stream<PasswordModel> getPasswordById(
      String id, String uid, groupId, BuildContext context) {
    return _PasswordsCollection.doc(id).snapshots().asyncMap((snapshot) async {
      final groupKey = await getGroupKey(groupId, uid, context);
      if (groupKey != null) {
        return PasswordModel.passwordDataFromSnapshotById(snapshot, groupKey);
      } else {
        return const PasswordModel(
            groupId: '',
            passwordId: '',
            password: '',
            dateCreated: '',
            userName: '',
            website: '');
      }
    });
  }

  // Get stream of group password
  Stream<List<GroupPassword>> getGroupPassword(String uid, context) {
    return _GroupPasswordsCollection.where('uid', isEqualTo: uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<GroupPassword> groupPasswords = [];
      for (var doc in snapshot.docs) {
        final groupId = doc.id;
        final masterKey = await getMasterKey(uid, groupId, context);

        if (masterKey != null) {
          final groupPasswordData = await _GroupPasswordsCollection.where(
                  'groupId',
                  isEqualTo: groupId)
              .get();
          final groupPassword = GroupPassword.groupPasswordDataFromSnapshot(
              groupPasswordData, masterKey);
          groupPasswords.addAll(
              groupPassword); // add the GroupPassword objects to the list
        }
      }
      return groupPasswords;
    }).handleError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString()))));
  }

  Stream<List<NotesGroup>> getNotesGroup(String uid, context) {
    return _NotesGroupCollection.where('uid', isEqualTo: uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<NotesGroup> groupPasswords = [];
      for (var doc in snapshot.docs) {
        final groupId = doc.id;
        final masterKey = await getMasterKey(uid, groupId, context);

        if (masterKey != null) {
          final noteGroupData =
              await _NotesGroupCollection.where('groupId', isEqualTo: groupId)
                  .get();
          final groupPassword =
              NotesGroup.noteGroupDataFromSnapshot(noteGroupData, masterKey);
          groupPasswords.addAll(
              groupPassword); // add the GroupPassword objects to the list
        }
      }
      return groupPasswords;
    }).handleError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString()))));
  }

  Stream<GroupPassword> getGroupPasswordWithGroupId(
      String groupId, String uid, BuildContext context) {
    return _GroupPasswordsCollection.doc(groupId)
        .snapshots()
        .asyncMap((snapshot) async {
      final masterKey = await getMasterKey(uid, groupId, context);

      return GroupPassword.groupPasswordDataFromSnapshotByGroupId(
          snapshot, masterKey ?? '');
    }).handleError(
      (e) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString()))),
    );
  }

  Stream<List<PasswordModel>> viewGroupPasswordWithKey(
      String groupId, String uid, BuildContext context) {
    return _PasswordsCollection.where('groupId', isEqualTo: groupId)
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
      return await _GroupPasswordsCollection.doc(groupId).update({
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
  Future<void> deletePasswordById(
      String passwordId, BuildContext context) async {
    try {
      return await _PasswordsCollection.doc(passwordId).delete().then((value) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Password deleted'))));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ! Delete password with group ID
  Future<void> deleteGroupPassword(String groupId, BuildContext context) async {
    try {
      return await _PasswordsCollection.where('groupId', isEqualTo: groupId)
          .get()
          .then((snapshot) {
            for (var doc in snapshot.docs) {
              doc.reference.delete();
            }
            // then delete group password
          })
          .then((value) =>
              _MasterKeysCollection.where('groupId', isEqualTo: groupId)
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              }))
          .then((value) => _GroupPasswordsCollection.doc(groupId)
              .delete()
              .then((value) => Navigator.pop(context)));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
