import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class SavePassword extends StatefulWidget {
  const SavePassword({super.key, required this.generatedPassword});
  final String generatedPassword;

  @override
  State<SavePassword> createState() => _SavePasswordState();
}

class _SavePasswordState extends State<SavePassword> {
  bool _createNewGroup = false;
  String? _selectedGroupId;
  String? groupName;
  String? userName;
  String? description;
  bool isLoading = false;
  void _handleCreateNewGroupChanged(bool value) {
    setState(() {
      _createNewGroup = !_createNewGroup;
    });
  }

  void onGroupSelected(String groupId) {
    setState(() {
      _selectedGroupId = groupId;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    final store = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        automaticallyImplyLeading: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            children: [
              OneSavePassword(uid: uid),
              const SizedBox(height: 20),
              TwoSavePassword(generatedPassword: widget.generatedPassword),
              const SizedBox(height: 20),
              Four(
                  onIncludeSymbolChanged: _handleCreateNewGroupChanged,
                  title: 'Create New Group'),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).hintColor),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _createNewGroup
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a Group name';
                                    }
                                    if (value.length < 3) {
                                      return 'Group name must b more in length';
                                    }
                                    if (value.contains(' ')) {
                                      return 'Please enter a valid name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    groupName = value;
                                  },
                                  decoration: const InputDecoration(
                                      label: Text('Group name'),
                                      hintText: 'Enter a group name')),
                            )
                          : ThreeSavePassword(
                              uid: uid ?? '',
                              onChanged: onGroupSelected,
                            ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              if (value.length < 3) {
                                return 'Name must b more in length';
                              }
                              if (value.contains(' ')) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              userName = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'User-name',
                              hintText: 'enter your account username',
                            ),
                          )),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          maxLines: 3,
                          maxLength: 200,
                          onSaved: (value) {
                            description = value;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'enter a description '),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // trigger onSave fuction form form key
                      setState(() {
                        isLoading = true;
                      });
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        if (_createNewGroup) {
                          await store
                              .savePassword(
                                  _createNewGroup,
                                  null,
                                  widget.generatedPassword,
                                  groupName,
                                  uid!,
                                  description!,
                                  userName!,
                                  context)
                              .then((value) => Navigator.pop(context));
                        } else {
                          await store
                              .savePassword(
                                  _createNewGroup,
                                  _selectedGroupId,
                                  widget.generatedPassword,
                                  null,
                                  uid!,
                                  description!,
                                  userName!,
                                  context)
                              .then((value) => Navigator.pop(context));
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
                            color: Theme.of(context).scaffoldBackgroundColor)
                        : const Text('SAVE PASSWORD',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ThreeSavePassword extends StatefulWidget {
  const ThreeSavePassword({
    Key? key,
    required this.uid,
    required this.onChanged,
  }) : super(key: key);

  final String uid;
  final Function(String) onChanged;

  @override
  State<ThreeSavePassword> createState() => _ThreeSavePasswordState();
}

class _ThreeSavePasswordState extends State<ThreeSavePassword> {
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return StreamBuilder<List<GroupPassword>>(
      stream: store.getGroupPassword(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'No Group found',
              ),
              value: _selectedGroup,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGroup = newValue;
                });
                // call your callback function here with the new value
                widget.onChanged(_selectedGroup!);
              },
              items: const [],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            final data = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Select Group',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please create group';
                  }
                  return null;
                },
                value: _selectedGroup,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGroup = newValue;
                  });
                  // call your callback function here with the new value
                  widget.onChanged(_selectedGroup!);
                },
                items: data!.map((group) {
                  return DropdownMenuItem<String>(
                    value: group.groupId,
                    child: Text(group.groupName),
                  );
                }).toList(),
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TwoSavePassword extends StatelessWidget {
  const TwoSavePassword({
    super.key,
    required this.generatedPassword,
  });

  final String generatedPassword;

  @override
  Widget build(BuildContext context) {
    return Two(generatedPassword: generatedPassword);
  }
}

class OneSavePassword extends StatelessWidget {
  const OneSavePassword({
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
          'Save Password',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              letterSpacing: 1, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          radius: 35,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: 33,
            backgroundImage:
                NetworkImage('https://api.multiavatar.com/$uid Bond.png'),
          ),
        )
      ],
    );
  }
}
