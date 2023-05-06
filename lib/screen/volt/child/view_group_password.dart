import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:uuid/uuid.dart';

class ViewGroupPassword extends StatelessWidget {
  const ViewGroupPassword({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return StreamBuilder<List<PasswordModel>>(
      stream: store.viewGroupPassword(groupId, context),
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
                actions: [
                  PopupMenuButton(
                    onSelected: (value) async {
                      if (value == 0) {
                        // TODO
                      } else if (value == 1) {
                        // TODO
                      } else if (value == 2) {
                        await store
                            .deleteGroupPassword(groupId, context)
                            .then((value) => Navigator.pop(context));
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                            value: 1, child: Text('Rename group')),
                        const PopupMenuItem(
                            value: 2, child: Text('Delete group')),
                      ];
                    },
                  )
                ],
              ),
              floatingActionButton: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: ElevatedButton(
                              onPressed: () {
                                // TODO
                              },
                              child: const Text('Add password')),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add)),
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
      },
    );
  }
}
