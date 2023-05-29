import 'package:flutter/material.dart';

Future<dynamic> brandAlertDialogSingleButton(
    String message, BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Oops!'),
        content: Text(
          message,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
