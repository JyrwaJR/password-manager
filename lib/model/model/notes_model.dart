import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class NotesModel {
  final String groupId;
  final String notesId;
  final String notes;
  final String dateCreated;
  final String notesName;
  final String title;

  NotesModel({
    required this.groupId,
    required this.notesId,
    required this.notes,
    required this.dateCreated,
    required this.notesName,
    required this.title,
  });
  static List<NotesModel> listOfNotesDataFromSnapshot(
      QuerySnapshot snapshot, key, BuildContext context) {
    return snapshot.docs.map((doc) {
      return NotesModel(
        groupId: doc['groupId'] ?? '',
        notesId: doc['notesId'] ?? '',
        notes: decryptField(doc['notes'], key, context),
        title: decryptField(doc['title'], key, context),
        notesName: decryptField(doc['notesName'], key, context),
        dateCreated: decryptField(doc['dateCreated'], key, context),
      );
    }).toList();
  }

  static NotesModel notesDataFromSnapshotById(
      DocumentSnapshot doc, String masterKey, BuildContext context) {
    return NotesModel(
      groupId: doc['groupId'] ?? '',
      notesId: doc['passwordId'] ?? '',
      notes: decryptField(doc['password'], masterKey, context),
      notesName: decryptField(doc['userName'], masterKey, context),
      title: decryptField(doc['title'], masterKey, context),
      dateCreated: decryptField(doc['dateCreated'], masterKey, context),
    );
  }
}
