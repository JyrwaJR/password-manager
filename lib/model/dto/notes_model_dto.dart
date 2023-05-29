import 'package:flutter/material.dart';
import 'package:password_manager/constant/export_constant.dart';

class NotesModelDTO {
  final String notesId;
  final String notes;
  final String dateCreated;
  final String notesName;
  final String title;

  NotesModelDTO({
    required this.notesId,
    required this.notes,
    required this.dateCreated,
    required this.notesName,
    required this.title,
  });
  // create to map
  Map<String, dynamic> toMap(
    String masterKey,
    String groupId,
    BuildContext context,
  ) {
    return {
      'groupId': groupId,
      'notesId': notesId,
      'notes': encryptField(notes, masterKey, context),
      'notesName': encryptField(notesName, masterKey, context),
      'title': encryptField(title, masterKey, context),
      'dateCreated': encryptField(dateCreated, masterKey, context),
    };
  }
}
