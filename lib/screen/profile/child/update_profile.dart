import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _UpdateProfileState extends State<UpdateProfile> {
  final store = FirebaseFirestore.instance;
  final TextEditingController _userNameController = TextEditingController();
  String isUserName = '';
  String isNewUserName = '';

  void getUserName(String uid) async {
    final userData = await store.collection('Users').doc(uid).get();

    setState(() {
      isUserName = userData.data()?['userName'];
      setState(() {
        _userNameController.text = isUserName;
      });
    });
  }

  @override
  void initState() {
    getUserName(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return isUserName.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const AppBarTitle(title: 'Update profile'),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                BrandTitle(title: isUserName, id: widget.uid),
                const SizedBox(height: 100),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        initialValue: _userNameController.text,
                        maxLength: 20,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < 3) {
                            return 'username must contain more than 3 character';
                          }
                          if (value.length > 20) {
                            return 'username must contain less than 20 character';
                          }
                          if (value == ' ') {
                            return 'Please enter a valid username';
                          }
                          if (value.contains(' ')) {
                            return 'user name should not contain spaces';
                          }
                          if (isUserName.toLowerCase() == value.toLowerCase()) {
                            return 'Please enter a new username';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            isNewUserName = value;
                          });
                        },
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'User Name',
                          hintText: 'Please Enter Your user Name',
                          helperText: 'Enter your user name',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BrandButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final firestore = FirebaseFirestore.instance;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Oops!'),
                                content: const Text(
                                    'Are you sure you want to change your username?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        await firestore
                                            .collection('Users')
                                            .doc(widget.uid)
                                            .update({'userName': isNewUserName})
                                            .then((value) => ScaffoldMessenger
                                                    .of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'User name updated successfully'))))
                                            .then((value) => context.goNamed(
                                                  'profile',
                                                  queryParameters: {
                                                    'uid': widget.uid
                                                  },
                                                ))
                                            .then((value) =>
                                                Navigator.of(context).pop());
                                      },
                                      child: const Text("YES")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("NO"))
                                ],
                              ),
                            );
                          }
                        },
                        title: 'Change')
                  ],
                )
              ],
            ));
  }
}
