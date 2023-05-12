import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:uuid/uuid.dart';

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
  String? website;
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
              BrandTitle(title: 'Save Passwords', id: uid!),
              const SizedBox(height: 20),
              BrandPasswordDisplay(password: widget.generatedPassword),
              const SizedBox(height: 20),
              BrandTextWithSwitch(
                  onChanged: _handleCreateNewGroupChanged,
                  title: 'Create New Group'),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
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
                                  maxLength: 20,
                                  onChanged: (value) {
                                    setState(() {
                                      groupName = value;
                                    });
                                  },
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
                              uid: uid,
                              onChanged: onGroupSelected,
                            ),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                userName = value;
                              });
                            },
                            maxLength: 50,
                            keyboardType: TextInputType.emailAddress,
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
                            onChanged: (value) {
                              setState(() {
                                website = value;
                              });
                            },
                            maxLength: 20,
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a website';
                              }
                              if (value.length < 3) {
                                return 'Name must b more in length';
                              }
                              if (value.contains(' ')) {
                                return 'Please enter a valid website';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              website = value;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Website link',
                              hintText: 'Enter your website link',
                            ),
                          )),
                      const SizedBox(height: 20),
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
                      setState(() {
                        isLoading = true;
                      });
                      FocusScope.of(context).unfocus();
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        final passwordId = const Uuid().v1();
                        if (_createNewGroup) {
                          final groupId = await store.createGroupForPassword(
                              groupName!, uid, context);
                          if (!mounted) {
                            return;
                          }
                          await store
                              .addPassword(
                                PasswordDTO(
                                  passwordId: passwordId,
                                  password: widget.generatedPassword,
                                  userName: userName!,
                                  website: website!,
                                ),
                                groupId ?? '',
                                uid,
                                context,
                              )
                              .then((value) => Navigator.pop(context));
                        } else {
                          await store.addPassword(
                              PasswordDTO(
                                passwordId: passwordId,
                                password: widget.generatedPassword,
                                userName: userName!,
                                website: website!,
                              ),
                              _selectedGroupId!,
                              uid,
                              context);

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
      stream: store.getGroupPassword(widget.uid, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please create group';
                }
                return null;
              },
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
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Please create a group',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a new group';
                    }
                    return null;
                  },
                  onChanged: null,
                  items: const []),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
