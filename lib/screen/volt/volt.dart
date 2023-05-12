import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Volt extends StatefulWidget {
  const Volt({
    super.key,
  });
  @override
  State<Volt> createState() => _VoltState();
}

// create Global form key
String groupName = '';

final TextEditingController _groupNameController = TextEditingController();

class _VoltState extends State<Volt> {
  final _firestore = FirestoreService();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'VOLT'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            BrandTitle(
              id: uid!,
              title: 'Passwords',
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), label: Text('Search')),
              onTap: () {
                const AlertDialog(
                  title: Text('Search'),
                  content: Text('Enter a username to search for.'),
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<GroupPassword>>(
              stream:
                  _firestore.getGroupPassword(auth.currentUser!.uid, context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const PasswordCardShimmer();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return TwoVolt(model: snapshot.data!);
                    // return Container();
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                          child: Text(
                        'Please create a group ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    );
                  }
                } else {
                  return const PasswordCardShimmer();
                }
              },
            ),
          ],
        ),
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
                                        ?.fontSize),
                              )),
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

class PasswordCardShimmer extends StatelessWidget {
  const PasswordCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      separatorBuilder: (BuildContext context, int index) {
        return Card(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).highlightColor,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  radius: 23,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    width: 200,
                    height: 12,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    width: 250,
                    height: 10,
                  )
                ],
              )
            ],
          ),
        ));
      },
      itemBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 5,
        );
      },
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
        return const SizedBox(height: 5);
      },
    );
  }
}

class OneVolt extends StatelessWidget {
  const OneVolt({
    super.key,
    required this.uid,
    required this.title,
  });

  final String uid;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              letterSpacing: 3, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        CircleAvatar(
          radius: 34,
          backgroundColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: 30,
            child: CachedNetworkImage(
              imageUrl: "https://api.multiavatar.com/$uid Bond.png",
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                if (error is SocketException) {
                  return const Center(child: Icon(Icons.error_outline));
                } else if (error is TimeoutException) {
                  return const Center(child: Text('Request timed out'));
                } else {
                  return const Center(child: Text('Failed to load image'));
                }
              },
              imageBuilder: (context, imageProvider) {
                return Image.network(
                  "https://api.multiavatar.com/$uid Bond.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    if (error is SocketException) {
                      return const Center(child: Icon(Icons.error_outline));
                    } else if (error is TimeoutException) {
                      return const Center(child: Text('Request timed out'));
                    } else {
                      return const Center(child: Text('Failed to load '));
                    }
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class PasswordGroupCard extends StatelessWidget {
  const PasswordGroupCard({
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
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 23,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://api.multiavatar.com/$groupId Bond.png",
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          if (error is SocketException) {
                            return const Center(
                                child: Icon(Icons.error_outline));
                          } else if (error is TimeoutException) {
                            return const Center(
                                child: Text('Request timed out'));
                          } else {
                            return const Center(
                                child: Text('Failed to load image'));
                          }
                        },
                        imageBuilder: (context, imageProvider) {
                          return Image.network(
                            "https://api.multiavatar.com/$groupId Bond.png",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              if (error is SocketException) {
                                return const Center(
                                    child: Icon(Icons.error_outline));
                              } else if (error is TimeoutException) {
                                return const Center(
                                    child: Icon(Icons.error_outline));
                              } else {
                                return const Center(
                                    child: Icon(Icons.error_outline));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    capitalizeFirstLetter(groupPassword.groupName),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
