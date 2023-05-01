import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 80,
              child: CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(
                  "https://api.multiavatar.com/$uid Bond.png",
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextButton.icon(
            onPressed: () async {
              return await auth
                  .signOut(context)
                  .then((value) => context.go('/'));
            },
            label: const Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
    );
  }
}
