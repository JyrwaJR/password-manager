import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/widget/shimmer/brand_title_shimmer.dart';

class ViewGroupPassword extends StatefulWidget {
  final String groupId;
  const ViewGroupPassword({
    super.key,
    required this.groupId,
  });
  @override
  State<ViewGroupPassword> createState() => _ViewGroupPasswordState();
}

final store = FirestoreService();
final auth = FirebaseAuth.instance;

class _ViewGroupPasswordState extends State<ViewGroupPassword> {
  final uid = auth.currentUser?.uid;
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
              await store.deleteGroupPassword(widget.groupId, context);
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
            OneViewGroupPassword(groupId: widget.groupId),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) => AddCredential(groupId: widget.groupId),
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

class TitleViewGroupPassword extends StatelessWidget {
  final String groupId;
  const TitleViewGroupPassword({
    required this.groupId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<GroupPassword>(
        stream: store.getGroupPasswordWithGroupId(groupId, uid!, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const BrandTitleShimmer();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return BrandTitle(
                title: capitalizeFirstLetter(data?.groupName ?? ''),
                id: groupId,
              );
            } else {
              return const BrandTitleShimmer();
            }
          } else {
            return const BrandTitleShimmer();
          }
        });
  }
}

class OneViewGroupPassword extends StatelessWidget {
  final String groupId;

  const OneViewGroupPassword({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<List<PasswordModel>>(
      stream: store.viewGroupPasswordWithKey(groupId, uid!, context),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const OneViewGroupPasswordShimmer();
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final password = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: password.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onLongPress: () async {
                    // TODO show delete button
                  },
                  child: PasswordCard(
                    password: password[index],
                  ),
                );
              },
            );
          } else {
            return const OneViewGroupPasswordShimmer();
          }
        } else {
          return const OneViewGroupPasswordShimmer();
        }
      },
    );
  }
}

class OneViewGroupPasswordShimmer extends StatelessWidget {
  const OneViewGroupPasswordShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
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
                        backgroundColor: Theme.of(context).highlightColor,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 23,
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
                            Container(
                              height: 16,
                              width: 180,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Container(
                              height: 13,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    super.key,
    required this.password,
  });
  final PasswordModel password;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
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
                        imageUrl: "https://api.multiavatar.com/$uid Bond.png",
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
                          password.userName,
                          // AES256Bits.decrypt(password.userName, masterKey),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(password.website,
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
                        copyToClipboard(password.password);
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
