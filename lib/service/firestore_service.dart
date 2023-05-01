import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class FirestoreService {
  final firestore = FirebaseFirestore.instance;

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
}
