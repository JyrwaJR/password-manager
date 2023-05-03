import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class ViewGroupPassword extends StatelessWidget {
  const ViewGroupPassword({super.key, required this.groupId});
  final String groupId;
  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return StreamBuilder<List<PasswordModel>>(
        stream: store.viewGroupPassword(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Back', style: TextStyle(letterSpacing: 1)),
                  automaticallyImplyLeading: true,
                ),
                body: Center(
                  child: Text(snapshot.data!.length.toString()),
                ),
              );
            } else {
              return const Center(
                child: Text('No data found'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
