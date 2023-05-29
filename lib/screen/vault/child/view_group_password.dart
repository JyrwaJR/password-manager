import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/widget/view_password_bottom_sheet.dart';

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

void onSelectActionButton(
    String value, String groupId, BuildContext context) async {
  if (value == '0') {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          RenameGroupBottomSheet(groupId: groupId, isPasswordGroup: true),
    );
  } else if (value == '1') {
    showDialog(
      context: context,
      builder: (context) => const GetApiKeyNotYetImplemented(),
    );
  } else if (value == '2') {
    await deleteGroupWithGroupIdAlertBox(context, true, groupId);
  }
}

class _ViewGroupPasswordState extends State<ViewGroupPassword> {
  final uid = auth.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              onSelectActionButton(value, widget.groupId, context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '0', child: Text('Rename')),
              const PopupMenuItem(value: '1', child: Text('Get Key')),
              const PopupMenuItem(value: '2', child: Text('Delete')),
            ],
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
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            showDragHandle: true,
            isScrollControlled: true,
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
      },
    );
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
          if (snapshot.hasData || snapshot.data!.isNotEmpty) {
            final password = snapshot.data;
            return password.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: password.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PasswordCard(
                        password: password[index],
                      );
                    },
                  )
                : Center(
                    child: Text(
                      'This group has no password',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall?.fontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
    return InkWell(
      onTap: () {
        copyToClipboard(password.password);
        BrandSnackbar.showSnackBar(context, 'Password copy successful');
      },
      child: Card(
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
                        child: BrandCachedImages(uid: uid, password: password),
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
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            viewPasswordBottomSheet(context, password);
                          },
                          child: const Text('Password'),
                        ),
                        PopupMenuItem(
                          onTap: () async {
                            await store.deletePasswordById(
                                password.passwordId, context);
                          },
                          child: const Text('Delete'),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BrandCachedImages extends StatelessWidget {
  const BrandCachedImages({
    super.key,
    required this.uid,
    required this.password,
  });

  final String uid;
  final PasswordModel password;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "https://api.multiavatar.com/$uid Bond.png",
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        if (error is SocketException) {
          return const Center(child: Icon(Icons.error_outline));
        } else if (error is TimeoutException) {
          return const Center(child: Icon(Icons.error_outline));
        } else {
          return const Center(child: Icon(Icons.error_outline));
        }
      },
      imageBuilder: (context, imageProvider) {
        return Image.network(
          "https://api.multiavatar.com/${password.passwordId} Bond.png",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            if (error is SocketException) {
              return const Center(child: Icon(Icons.error_outline));
            } else if (error is TimeoutException) {
              return const Center(child: Icon(Icons.error_outline));
            } else {
              return const Center(child: Icon(Icons.error_outline));
            }
          },
        );
      },
    );
  }
}
