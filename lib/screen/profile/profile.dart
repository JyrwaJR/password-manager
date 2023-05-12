import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Profile extends StatefulWidget {
  const Profile({required this.uid, super.key});
  final String uid;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  onAccountSettingsTap(value) {
    if (value == 'Profile') {
      context.goNamed('update profile',
          queryParameters: <String, String>{'uid': widget.uid});
    } else if (value == 'Account Settings') {
      context.goNamed('account settings',
          queryParameters: <String, String>{'uid': widget.uid});
    } else if (value == 'Change Password') {
      context.goNamed('change password',
          queryParameters: <String, String>{'uid': widget.uid});
    } else if (value == 'Master-Key') {
      context.goNamed('master key',
          queryParameters: <String, String>{'uid': widget.uid});
    } else if (value == 'Help Center') {
      context.goNamed('help center',
          queryParameters: <String, String>{'uid': widget.uid});
    } else if (value == 'Report Bug') {
      context.goNamed('report bug',
          queryParameters: <String, String>{'uid': widget.uid});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Try again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();
    final store = FirestoreService();
    return StreamBuilder<UserModel>(
      stream: store.getUserData(widget.uid, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const AppBarTitle(title: "PROFILE"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('Do you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await auth.signOut(context).then((value) {
                                  Navigator.pop(context);
                                  context.go('/');
                                });
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'LOGOUT',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    const SizedBox(height: 30),
                    OneProfile(uid: widget.uid, user: user),
                    const SizedBox(height: 30),
                    Text(
                      'GENERALS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TwoProfile(
                      title: 'Profile',
                      onTap: onAccountSettingsTap,
                    ),
                    TwoProfile(
                      title: 'Account Settings',
                      onTap: onAccountSettingsTap,
                    ),
                    TwoProfile(
                      title: 'Change Password',
                      onTap: onAccountSettingsTap,
                    ),
                    TwoProfile(
                      title: 'Master-Key',
                      onTap: onAccountSettingsTap,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'OTHERS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TwoProfile(
                      title: 'Help Center',
                      onTap: onAccountSettingsTap,
                    ),
                    TwoProfile(
                      title: 'Report Bug',
                      onTap: onAccountSettingsTap,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }
}

class Alert extends StatelessWidget {
  const Alert({
    required this.title,
    super.key,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('ok'),
        ),
      ],
    );
  }
}

class TwoProfile extends StatelessWidget {
  const TwoProfile({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String title;

  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: () {
          onTap(title);
        },
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OneProfile extends StatelessWidget {
  const OneProfile({
    super.key,
    required this.uid,
    required this.user,
  });

  final String uid;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 85,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 80,
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
                        return const Center(
                            child: Text('Failed to load image'));
                      }
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            user.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).dividerColor,
            ),
          )
        ],
      ),
    );
  }
}

class OneSkell extends StatelessWidget {
  const OneSkell({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 85,
            backgroundColor: Theme.of(context).primaryColor,
            child: const CircleAvatar(
              radius: 80,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 2),
          Container(
            height: 20,
            width: 250,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }
}
