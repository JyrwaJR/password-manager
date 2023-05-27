import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class RenameNotesBottomSheet extends StatefulWidget {
  const RenameNotesBottomSheet({
    super.key,
    required this.notesId,
    required this.uid,
    required this.groupId,
  });
  final String notesId;
  final String uid;
  final String groupId;
  @override
  State<RenameNotesBottomSheet> createState() => _RenameNotesBottomSheetState();
}

class _RenameNotesBottomSheetState extends State<RenameNotesBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? isNewNotesName;
  final store = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NotesModel>(
        stream: null,
        builder: (context, snapshot) {
          return Card(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const DashButtonForBottomSheet(),
                  BrandTitle(title: 'Rename', id: widget.notesId),
                  const SizedBox(height: 20),
                  Text(
                    'New name! Good choice',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Theme.of(context)
                          .primaryTextTheme
                          .headlineSmall
                          ?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'a good name is a good way to remember your group',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .primaryTextTheme
                            .bodyLarge
                            ?.fontSize,
                        color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(height: 20),
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
                          isNewNotesName = value;
                        });
                      },
                      keyboardType: TextInputType.name,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                        hintText: 'example: social media',
                        helperText: 'please enter a name for your group',
                      )),
                  const SizedBox(height: 20),
                  BrandButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (isNewNotesName != null) {
                            await store
                                .updateNotesNameByNoteId(
                                  widget.notesId,
                                  widget.groupId,
                                  widget.uid,
                                  isNewNotesName!,
                                  context,
                                )
                                .then((value) => Navigator.pop(context));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter group name')));
                          }
                        }
                      },
                      title: "Change"),
                ],
              ),
            ),
          );
        });
  }
}
