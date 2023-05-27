import 'package:cloud_firestore/cloud_firestore.dart';
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
      QuerySnapshot snapshot, key) {
    return snapshot.docs.map((doc) {
      return NotesModel(
        groupId: doc['groupId'] ?? '',
        notesId: doc['notesId'] ?? '',
        notes: decryptField(doc['notes'], key),
        title: decryptField(doc['title'], key),
        notesName: decryptField(doc['notesName'], key),
        dateCreated: decryptField(doc['dateCreated'], key),
      );
    }).toList();
  }

  static NotesModel notesDataFromSnapshotById(
      DocumentSnapshot doc, String masterKey) {
    return NotesModel(
      groupId: doc['groupId'] ?? '',
      notesId: doc['passwordId'] ?? '',
      notes: decryptField(doc['password'], masterKey),
      notesName: decryptField(doc['userName'], masterKey),
      title: decryptField(doc['title'], masterKey),
      dateCreated: decryptField(doc['dateCreated'], masterKey),
    );
  }
}
