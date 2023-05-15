import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class GroupPasswords extends StatefulWidget {
  const GroupPasswords({super.key});

  @override
  State<GroupPasswords> createState() => _GroupPasswordsState();
}

class _GroupPasswordsState extends State<GroupPasswords> {
  final store = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: store.getGroupPassword(uid!, context),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PasswordCardShimmer();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return TwoGroupPassword(model: snapshot.data!);
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 50),
                    const BrandSizeBox(
                      height: 20,
                    ),
                    Text(
                      'Oops! No group found',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall?.fontSize,
                        fontWeight: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.fontWeight,
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const PasswordCardShimmer();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoDialog(
            useRootNavigator: false,
            context: context,
            builder: (context) => const CreateGroupBottomSheet(),
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class TwoGroupPassword extends StatelessWidget {
  const TwoGroupPassword({
    super.key,
    required this.model,
  });

  final List<GroupPassword> model;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 5),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            context.goNamed('view group password',
                queryParameters: <String, String>{
                  'groupId': model[index].groupId,
                });
          },
          child: PasswordGroupCard(
            groupPassword: model[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}

class CreateGroupBottomSheet extends StatefulWidget {
  const CreateGroupBottomSheet({
    super.key,
  });

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
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Back'),
      ),
      body: Card(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              const SizedBox(
                height: 10,
              ),
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
                    'A good way to save your detail form one provider ',
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
                    maxLength: 20,
                    onChanged: (value) {
                      setState(() {
                        groupName = value;
                      });
                    },
                    autofocus: true,
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
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                final groupId =
                                    await store.createGroupForPassword(
                                        groupName ?? '', uid, context);
                                if (groupId != null) {
                                  if (!mounted) {
                                    return;
                                  }

                                  context.goNamed('view group password',
                                      queryParameters: <String, String>{
                                        'groupId': groupId,
                                        'uid': uid
                                      });
                                  Navigator.pop(context);
                                  setState(() {
                                    isLoading = false;
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
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
