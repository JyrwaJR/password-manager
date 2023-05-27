import 'package:flutter/material.dart';

class GetApiKeyNotYetImplemented extends StatelessWidget {
  const GetApiKeyNotYetImplemented({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Oops!'),
      content: const Text(
          '''Get api feature wasn't yet implemented as it need to keep a safe keeping of the key. \n\n please try again later.'''),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Ok'))
      ],
    );
  }
}
