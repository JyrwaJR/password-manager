import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class AddCredential extends StatefulWidget {
  const AddCredential({super.key, required this.groupId});
  final String groupId;

  @override
  State<AddCredential> createState() => _AddCredentialState();
}

class _AddCredentialState extends State<AddCredential> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            BrandTitle(title: 'Add Credential', id: widget.groupId),
            const SizedBox(height: 20),
            // OneViewGroupPassword(groupId: widget.groupId),
          ],
        ),
      ),
    );
  }
}
