import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: OutlinedButton(
            onPressed: () async {
              await auth
                  .signOut()
                  .then((value) => context.go(context.namedLocation('email')));
            },
            child: const Text('Home')),
      ),
    );
  }
}
