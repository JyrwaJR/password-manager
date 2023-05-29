import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({
    super.key,
    required this.isPasswordGroup,
  });
  final bool isPasswordGroup;
  @override
  State<CreateGroupBottomSheet> createState() => _CreateGroupBottomSheetState();
}

class _CreateGroupBottomSheetState extends State<CreateGroupBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? groupName;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final store = FirestoreService();
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          const SizedBox(height: 10),
          BrandTitle(title: 'Create Group', id: uid!),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Please enter a group name',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: Theme.of(context)
                        .primaryTextTheme
                        .headlineSmall
                        ?.fontSize,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'A good way to group your items',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                    fontSize:
                        Theme.of(context).primaryTextTheme.bodyLarge?.fontSize,
                    color: Theme.of(context).hintColor),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLength: 20,
                onChanged: (value) {
                  setState(() {
                    groupName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  if (value.trim().isEmpty) {
                    return 'Group name cannot contain only spaces';
                  }
                  if (value.startsWith(' ') || value.endsWith(' ')) {
                    return 'Group name cannot start or end with a space';
                  }
                  if (value.length < 3) {
                    return 'Group name must be more than 3 characters';
                  }
                  return null; // Return null if the input is valid.
                },
                decoration: const InputDecoration(
                  labelText: 'Group name',
                  hintText: 'example',
                  helperText: 'Please enter your group name',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            if (widget.isPasswordGroup) {
                              await store
                                  .createGroupForPassword(
                                      groupName!, uid, context)
                                  .then((value) {
                                Navigator.pop(context);
                                return context.go(context.namedLocation(
                                    'view group password',
                                    queryParameters: {'groupId': value}));
                              });
                            } else {
                              await store
                                  .createGroupForNote(groupName!, uid, context)
                                  .then((value) {
                                Navigator.pop(context);
                                return context.go(context.namedLocation(
                                    'view notes',
                                    queryParameters: {'groupId': value}));
                              });
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).cardColor,
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.fontSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Future<dynamic> createGroupBottomSheet(
    BuildContext context, bool isGroupPassword) {
  return showModalBottomSheet(
    context: context,
    elevation: 12,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => CreateGroupBottomSheet(
      isPasswordGroup: isGroupPassword,
    ),
  );
}
