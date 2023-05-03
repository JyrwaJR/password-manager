import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Volt extends StatefulWidget {
  const Volt({super.key});

  @override
  State<Volt> createState() => _VoltState();
}

// create Global form key
String groupName = '';

final TextEditingController _groupNameController = TextEditingController();

class _VoltState extends State<Volt> {
  final _firestore = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    final store = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back', style: TextStyle(letterSpacing: 1)),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            OneVolt(uid: uid),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), label: Text('Search')),
              readOnly: true,
              onTap: () {
                const AlertDialog(
                  title: Text('Search'),
                  content: Text('Enter a username to search for.'),
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<GroupPassword>>(
              stream: store.getGroupPassword(auth.currentUser?.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data != null) {
                    return TwoVolt(model: snapshot.data!);
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                          child: Text(
                        'NO DATA FOUND',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
          onPressed: () {
            // show modal bottom sheet
            showDialog(
              context: context,
              useRootNavigator: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Create Group'),
                  content: SizedBox(
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onSaved: (newValue) {
                          _groupNameController.text = newValue!;
                        },
                        controller: _groupNameController,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a name';
                          }
                          if (value.isEmpty) {
                            return 'Please enter a name';
                          }
                          if (value.contains(' ')) {
                            return 'Group name cannot contain space';
                          }
                          if (value.startsWith(' ')) {
                            return 'Group name cannot start with space';
                          }
                          if (value.length < 3) {
                            return 'Group name should be more than 3 in length';
                          }
                          return null;
                        },
                        maxLength: 20,
                        decoration: const InputDecoration(
                            label: Text('Group Name'),
                            helperMaxLines: 2,
                            helperText:
                                'its like a folder name which group your password.',
                            hintText: 'example'),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final name = _groupNameController.text;
                            await _firestore
                                .createGroupPassword(_groupNameController.text,
                                    uid ?? '', context)
                                .then((value) => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                            'Group create with name: $name'))));
                            if (!mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                    ),
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          label: const Text('Create'),
          icon: const Icon(Icons.add_outlined)),
    );
  }
}

class TwoVolt extends StatelessWidget {
  const TwoVolt({
    super.key,
    required this.model,
  });

  final List<GroupPassword> model;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            context.goNamed('view group password',
                queryParameters: <String, String>{
                  'groupId': model[index].groupId
                });
          },
          child: PasswordCard(
            groupPassword: model[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 5);
      },
    );
  }
}

class OneVolt extends StatelessWidget {
  const OneVolt({
    super.key,
    required this.uid,
  });

  final String? uid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Passwords',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              letterSpacing: 3, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          radius: 32,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: 30,
            backgroundImage:
                NetworkImage('https://api.multiavatar.com/$uid Bond.png'),
          ),
        )
      ],
    );
  }
}

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    super.key,
    required this.groupPassword,
  });
  final GroupPassword groupPassword;
  @override
  Widget build(BuildContext context) {
    String groupId = groupPassword.groupId;
    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                          'https://api.multiavatar.com/$groupId Bond.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    groupPassword.groupName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
