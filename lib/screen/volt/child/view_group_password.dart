import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class ViewGroupPassword extends StatefulWidget {
  final String groupId;
  const ViewGroupPassword({super.key, 
    required this.groupId,
  });
  @override
  State<ViewGroupPassword> createState() => _ViewGroupPasswordState();
}

final store = FirestoreService();
final auth = FirebaseAuth.instance;

class _ViewGroupPasswordState extends State<ViewGroupPassword> {
  final uid = auth.currentUser?.uid;
  String masterKey = '';
  _getKey(String groupId, String uid, BuildContext context) async {
    final key = await store.getGroupKey(groupId, uid, context);
    setState(() {
      masterKey = key!;
    });
  }

  @override
  void initState() {
    _getKey(widget.groupId, uid ?? '', context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await store.deleteGroupPassword(widget.groupId, context).then(
                    (value) => Navigator.pop(context),
                  );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            TitleViewGroupPassword(groupId: widget.groupId),
            const SizedBox(height: 20),
            OneViewGroupPassword(groupId: widget.groupId, masterKey: masterKey),
          ],
        ),
      ),
    );
  }
}

class TitleViewGroupPassword extends StatelessWidget {
  final String groupId;
  const TitleViewGroupPassword({
    required this.groupId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return StreamBuilder<GroupPassword>(
        stream: store.getGroupPasswordWithGroupId(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data?.groupName ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        letterSpacing: 3,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 30,
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
                                    child: Text('Request timed out'));
                              } else {
                                return const Center(
                                    child: Text('Failed to load image'));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class OneViewGroupPassword extends StatelessWidget {
  final String groupId;
  final String masterKey;
  const OneViewGroupPassword({
    super.key,
    required this.groupId,
    required this.masterKey,
  });

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return StreamBuilder<List<PasswordModel>>(
      stream: store.viewGroupPassword(groupId, context),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final password = snapshot.data;
            if (masterKey.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: password.length,
                itemBuilder: (BuildContext context, int index) {
                  return PasswordCard(
                    password: password[index],
                    masterKey: masterKey,
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    super.key,
    required this.password,
    required this.masterKey,
  });
  final PasswordModel password;
  final String masterKey;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: SizedBox(
          height: 100,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 23,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://api.multiavatar.com/${password.passwordId} Bond.png",
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
                            "https://api.multiavatar.com/${password.passwordId} Bond.png",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
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
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AES256Bits.decrypt(password.userName, masterKey),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(AES256Bits.decrypt(password.website, masterKey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        // copy to clipboard
                        copyToClipboard(AES256Bits.decrypt(
                          password.password,
                          masterKey,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password copy successful')));
                      },
                      icon: const Icon(Icons.copy))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
