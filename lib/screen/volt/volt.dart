import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VOLT',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return TwoVolt(model: snapshot.data!);
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
          ElevatedButton(onPressed: () async {}, child: const Text('Create')),
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
            final store = FirestoreService();
            final uid = FirebaseAuth.instance.currentUser?.uid;
            final key =
                await store.getGroupKey(model[index].groupId, uid!, context);
            context.goNamed('view group password',
                queryParameters: <String, String>{
                  'groupId': model[index].groupId,
                  'masterKey': key!,
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
                    groupPassword.groupName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
