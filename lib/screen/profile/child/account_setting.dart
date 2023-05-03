import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
