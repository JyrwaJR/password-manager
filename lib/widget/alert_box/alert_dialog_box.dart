import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

Future<void> deleteGroupWithGroupIdAlertBox(
    BuildContext context, bool isPasswordGroup, String groupId) {
  final store = FirestoreService();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Oop!'),
      content: const Text(
          'Note: Deleting this group will delete all the password and data inside it.\n\n Are you sure you want to delete'),
      actions: [
        TextButton(
          onPressed: () async {
            await store
                .deleteGroupPassword(groupId, isPasswordGroup, context)
                .then((value) => context.go('/vault'))
                .then((value) => Navigator.pop(context));
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        )
      ],
    ),
  );
}
