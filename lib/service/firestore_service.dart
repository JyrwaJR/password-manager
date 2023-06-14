// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/model/dto/notes_model_dto.dart';
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
    try {
      final masterKey = MasterKeyGenerator.generateKey();
      final findUser = await _UsersCollection.doc(userDTO.uid).get();
      if (findUser.data() != null) {
        BrandSnackbar.showSnackBar(context, 'Welcome back');
        return;
      }
      await _UsersCollection.doc(userDTO.uid)
          .set(userDTO.toMap(masterKey))
          .then((value) => BrandSnackbar.showSnackBar(
              context, 'User registered successfully!'));
      return;
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message ?? 'something went wrong');
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  Future<void> addMasterKey(
      String uid, String groupId, BuildContext context) async {
    final masterId = const Uuid().v4();
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
            .set(masterKeyDto.toMap(key, context))
            .then((value) =>
                BrandSnackbar.showSnackBar(context, 'Master key generated'));
      }
    } else {
      BrandSnackbar.showSnackBar(context, 'Master key already Generated');
    }
  }

  Future<String?> createGroupForPassword(
    String groupName,
    String uid,
    BuildContext context,
  ) async {
    final listOfGroups = await _GroupPasswordsCollection.get();
    final groups = listOfGroups.docs;

    if (groups.isNotEmpty) {
      final userKey = await getUserKey(uid, context);
      if (userKey == null) {
        return null;
      }
      for (final group in groups) {
        final masterKey = await getMasterKey(uid, group['groupId'], context);
        if (masterKey != null) {
          final eGroupName =
              decryptField(group['groupName'], masterKey, context);
          if (eGroupName.toLowerCase() == groupName.toLowerCase()) {
            BrandSnackbar.showSnackBar(context, 'Group name already exists');
            final id = group['groupId'];
            return id;
          }
        } else {
          BrandSnackbar.showSnackBar(
              context, 'Error retrieving group master key. Please try again');
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
          final eGroupName =
              decryptField(group['groupName'], masterKey, context);
          if (eGroupName.toLowerCase() == groupName.toLowerCase()) {
            BrandSnackbar.showSnackBar(context, 'Group name already exists');
            final id = group['groupId'];
            return id;
          }
        } else {
          BrandSnackbar.showSnackBar(
              context, 'Error retrieving group master key. Please try again');
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
        final groupId = const Uuid().v4();
        final masterId = const Uuid().v4();
        final masterKey = MasterKeyGenerator.generateKey();
        // ! Master
        final masterKeyDto = MasterKeyDTO(
            uid: uid,
            groupId: groupId,
            masterId: masterId,
            key: masterKey,
            dateCreated: DateTime.now().toIso8601String());
        await _MasterKeysCollection.doc(masterId)
            .set(masterKeyDto.toMap(userKey, context));
        // ! Group
        final groupKey = MasterKeyGenerator.generateKey();
        final groupPasswordDTO = GroupPasswordDTO(
            groupId: groupId,
            groupName: groupName,
            dateCreated: DateTime.now().toIso8601String(),
            uid: uid,
            key: groupKey);
        await _GroupPasswordsCollection.doc(groupId)
            .set(groupPasswordDTO.toMap(masterKey, context))
            .then((value) => context.goNamed('view group password',
                queryParameters: <String, String>{'groupId': groupId}));
        return groupId;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
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
        final groupId = const Uuid().v4();
        final masterId = const Uuid().v4();
        final masterKey = MasterKeyGenerator.generateKey();
        // ! Master
        final masterKeyDto = MasterKeyDTO(
            uid: uid,
            groupId: groupId,
            masterId: masterId,
            key: masterKey,
            dateCreated: DateTime.now().toIso8601String());
        await _MasterKeysCollection.doc(masterId)
            .set(masterKeyDto.toMap(userKey, context));
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
            .set(noteGroupDTO.toMap(masterKey, context));
        return groupId;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
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
              passwordDTO.toMap(key, groupId, context),
            )
            .then((value) => context.goNamed('view group password',
                queryParameters: <String, String>{'groupId': groupId}))
            .then((value) =>
                BrandSnackbar.showSnackBar(context, 'Password added'));
      } else {
        BrandSnackbar.showSnackBar(context, 'Please try again');
      }
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  Future<void> addNotes(
    NotesModelDTO noteDTO,
    String groupId,
    String uid,
    BuildContext context,
  ) async {
    try {
      final key = await getNotesGroupKey(groupId, uid, context);
      if (key != null) {
        await _NotesCollection.doc(noteDTO.notesId)
            .set(
              noteDTO.toMap(key, groupId, context),
            )
            .then((value) => context.goNamed('view notes',
                queryParameters: <String, String>{'groupId': groupId}))
            .then((value) => BrandSnackbar.showSnackBar(context, 'Note added'));
      } else {
        BrandSnackbar.showSnackBar(context, 'Please try again');
      }
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
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
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<String?> getNotesGroupKey(
      String groupId, String uid, BuildContext context) async {
    try {
      final masterKey = await getMasterKey(uid, groupId, context);
      if (masterKey != null) {
        final groupData =
            await firestore.collection('Notes Group').doc(groupId).get();
        if (groupData.data()?['key'] != null) {
          final encryptedKey = groupData.data()?['key'];
          final groupKey = decryptField(encryptedKey, masterKey, context);
          return groupKey;
        } else {
          return null;
        }
      }
      return null;
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
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
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
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
        BrandSnackbar.showSnackBar(context, 'User key not found');
        return null;
      }
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
      return null;
    }
  }

  Stream<UserModel> getUserData(String uid, BuildContext context) {
    return _UsersCollection.doc(uid)
        .snapshots()
        .map(UserModel.userDataFromSnapshot)
        .handleError((e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    });
  }

// Get stream of password with password id
  Stream<PasswordModel> getPasswordById(
      String id, String uid, groupId, BuildContext context) {
    return _PasswordsCollection.doc(id).snapshots().asyncMap((snapshot) async {
      final groupKey = await getGroupKey(groupId, uid, context);
      if (groupKey != null) {
        return PasswordModel.passwordDataFromSnapshotById(
            snapshot, groupKey, context);
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
              groupPasswordData, masterKey, context);
          groupPasswords.addAll(
              groupPassword); // add the GroupPassword objects to the list
        }
      }
      return groupPasswords;
    }).handleError((e) => BrandSnackbar.showSnackBar(context, e.toString()));
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
          final groupPassword = NotesGroup.noteGroupDataFromSnapshot(
              noteGroupData, masterKey, context);
          groupPasswords.addAll(
            groupPassword,
          ); // add the GroupPassword objects to the list
        }
      }
      return groupPasswords;
    }).handleError((e) => BrandSnackbar.showSnackBar(context, e.toString()));
  }

  Stream<GroupPassword> getGroupPasswordWithGroupId(
      String groupId, String uid, BuildContext context) {
    return _GroupPasswordsCollection.doc(groupId)
        .snapshots()
        .asyncMap((snapshot) async {
      final masterKey = await getMasterKey(uid, groupId, context);

      return GroupPassword.groupPasswordDataFromSnapshotByGroupId(
          snapshot, masterKey ?? '', context);
    }).handleError((e) => BrandSnackbar.showSnackBar(context, e.toString()));
  }

  Stream<NotesGroup> getNotesGroupByGroupId(
      String groupId, String uid, BuildContext context) {
    return _NotesGroupCollection.doc(groupId)
        .snapshots()
        .asyncMap((snapshot) async {
      final masterKey = await getMasterKey(uid, groupId, context);
      return NotesGroup.noteGroupDataFromSnapshotByGroupId(
          snapshot, masterKey ?? '', context);
    }).handleError((e) => BrandSnackbar.showSnackBar(context, e.toString()));
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
              snapshot, groupKey, context);
        })
        .handleError((e) => BrandSnackbar.showSnackBar(context, e.toString()))
        .cast<List<PasswordModel>>();
  }

  Stream<List<NotesModel>> viewNotesGroupWithKey(
    String groupId,
    String uid,
    BuildContext context,
  ) {
    return _NotesCollection.orderBy(
      'dateCreated',
      descending: true,
    )
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .asyncMap((snapshot) async {
          final groupKey = await getNotesGroupKey(groupId, uid, context);
          if (groupKey == null) {
            return [];
          }
          return NotesModel.listOfNotesDataFromSnapshot(
              snapshot, groupKey, context);
        })
        .handleError((e) => BrandSnackbar.showSnackBar(context, e.toString()))
        .cast<List<NotesModel>>();
  }

  // ! Update
  // ! Update Group Name
  Future<void> updateGroupName(String groupId, String uid, String groupName,
      bool isPasswordGroup, BuildContext context) async {
    if (uid.isNotEmpty) {
      try {
        final masterKey = await getMasterKey(uid, groupId, context);
        final encryptedGroupName = encryptField(groupName, masterKey!, context);
        if (isPasswordGroup) {
          final listOfGroups = await _GroupPasswordsCollection.get();
          final groups = listOfGroups.docs;

          if (groups.isNotEmpty) {
            final userKey = await getUserKey(uid, context);
            if (userKey == null) {
              return;
            }
            for (final group in groups) {
              final masterKey =
                  await getMasterKey(uid, group['groupId'], context);
              if (masterKey != null) {
                final eGroupName =
                    decryptField(group['groupName'], masterKey, context);
                if (eGroupName.toLowerCase() == groupName.toLowerCase()) {
                  BrandSnackbar.showSnackBar(
                      context, 'Group name already exists');
                  return;
                }
              } else {
                BrandSnackbar.showSnackBar(context,
                    'Error retrieving group master key. Please try again');
              }
            }
          }
          return await _GroupPasswordsCollection.doc(groupId).update({
            'groupName': encryptedGroupName,
            'dateCreated': encryptField(
                DateTime.now().toIso8601String(), masterKey, context)
          });
        } else {
          final listOfGroups = await _NotesGroupCollection.get();
          final groups = listOfGroups.docs;
          if (groups.isNotEmpty) {
            for (final group in groups) {
              final masterKey =
                  await getMasterKey(uid, group['groupId'], context);
              if (masterKey != null) {
                final eGroupName =
                    decryptField(group['groupName'], masterKey, context);
                if (eGroupName.toLowerCase() == groupName.toLowerCase()) {
                  BrandSnackbar.showSnackBar(
                      context, 'Group name already exists');
                }
              } else {
                BrandSnackbar.showSnackBar(context,
                    'Error retrieving group master key. Please try again');
              }
            }
          }
          return await _NotesGroupCollection.doc(groupId).update({
            'groupName': encryptedGroupName,
            'dateCreated': encryptField(
                DateTime.now().toIso8601String(), masterKey, context)
          });
        }
      } on FirebaseException catch (e) {
        BrandSnackbar.showSnackBar(context, e.message.toString());
      } catch (e) {
        BrandSnackbar.showSnackBar(context, e.toString());
      }
    }
  }

  Future<void> updateNotesNameByNoteId(
    String noteId,
    String groupId,
    String uid,
    String newName,
    BuildContext context,
  ) async {
    final groupKey = await getNotesGroupKey(groupId, uid, context);
    if (groupKey != null) {
      final noteslist =
          await _NotesCollection.where('groupId', isEqualTo: groupId).get();
      final notes = noteslist.docs;
      if (notes.isNotEmpty) {
        for (final note in notes) {
          final noteName = decryptField(note['notesName'], groupKey, context);
          if (noteName.toLowerCase() == newName.toLowerCase()) {
            BrandSnackbar.showSnackBar(context,
                'Note name already exists, Please choose another name');
            return;
          }
        }
      }
      return await _NotesCollection.doc(noteId).update({
        'notesName': encryptField(newName, groupKey, context),
        'dateCreated':
            encryptField(DateTime.now().toIso8601String(), groupKey, context)
      }).then(
          (value) => BrandSnackbar.showSnackBar(context, 'Note name updated'));
    } else {
      BrandSnackbar.showSnackBar(
          context, 'Error Getting key, Please try again,');
    }
  }

  // ! Delete
  Future<void> deletePasswordById(
    String passwordId,
    BuildContext context,
  ) async {
    try {
      return await _PasswordsCollection.doc(passwordId).delete().then(
          (value) => BrandSnackbar.showSnackBar(context, 'Password deleted'));
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  Future<void> deleteNotesById(
    String notesId,
    BuildContext context,
  ) async {
    try {
      return await _NotesCollection.doc(notesId).delete().then(
          (value) => BrandSnackbar.showSnackBar(context, 'Password deleted'));
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  // ! Delete password with group ID
  Future<void> deleteGroupPassword(
      String groupId, bool isPasswordGroup, BuildContext context) async {
    try {
      if (isPasswordGroup) {
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
            .then((value) => _GroupPasswordsCollection.doc(groupId).delete());
      } else {
        return await _NotesCollection.where('groupId', isEqualTo: groupId)
            .get()
            .then((snapshot) {
              for (var doc in snapshot.docs) {
                doc.reference.delete();
              }
            })
            .then((value) =>
                _MasterKeysCollection.where('groupId', isEqualTo: groupId)
                    .get()
                    .then((snapshot) {
                  for (var doc in snapshot.docs) {
                    doc.reference.delete();
                  }
                }))
            .then((value) => _NotesGroupCollection.doc(groupId).delete());
      }
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  // DeleteAccount
  Future<void> deleteAccount(String uid, BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      final groupsQuery =
          await _GroupPasswordsCollection.where('uid', isEqualTo: uid);
      final notesQuery =
          await _NotesGroupCollection.where('uid', isEqualTo: uid);

      final groupsSnapshot = await groupsQuery.get();
      final notesSnapshot = await notesQuery.get();

      for (var group in groupsSnapshot.docs) {
        final groupId = group['groupId'];
        await deleteGroupPassword(groupId, true, context);
      }

      for (var note in notesSnapshot.docs) {
        final groupId = note['groupId'];
        await deleteGroupPassword(groupId, false, context);
      }
      await auth.currentUser
          ?.delete()
          .then((value) =>
              BrandSnackbar.showSnackBar(context, 'User deleted successfully'))
          .then((value) => context.go('/'));
      await _UsersCollection.doc(uid).delete();

      // Redirect to home or login page
    } on FirebaseException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }
}
