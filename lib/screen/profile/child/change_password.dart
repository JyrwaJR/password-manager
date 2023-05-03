import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
