import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class RenameGroupBottomSheet extends StatefulWidget {
  const RenameGroupBottomSheet(
      {super.key, required this.groupId, required this.isPasswordGroup});
  final bool isPasswordGroup;
  final String groupId;

  @override
  State<RenameGroupBottomSheet> createState() => _RenameGroupBottomSheetState();
}

class _RenameGroupBottomSheetState extends State<RenameGroupBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? isNewGroupName;
  final store = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Container(
                  height: 8,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            BrandTitle(title: 'Rename', id: widget.groupId),
            const SizedBox(height: 10),
            TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter group name';
                  }
                  if (value.contains(' ')) {
                    return 'Group name should not contain space';
                  }
                  if (value.startsWith(' ')) {
                    return 'Group name should not start with space';
                  }
                  if (value.length > 20) {
                    return 'Group name should not be more than 20 characters';
                  }
                  if (value.length < 3) {
                    return 'Group name should not be less than 3 characters';
                  }
                  if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    return 'Group name should not contain special characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    isNewGroupName = value;
                    print(isNewGroupName);
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'Enter group name',
                )),
            const SizedBox(height: 10),
            BrandButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (isNewGroupName != null) {
                      await store
                          .updateGroupName(widget.groupId, uid ?? '',
                              isNewGroupName!, widget.isPasswordGroup, context)
                          .then((value) => Navigator.pop(context));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please enter group name')));
                    }
                  }
                },
                title: "Change"),
          ],
        ),
      ),
    );
  }
}
