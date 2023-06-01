import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/export.dart';

class ScaffoldWithBottomNavigationBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNavigationBar({required this.child, super.key});

  @override
  State<ScaffoldWithBottomNavigationBar> createState() =>
      _ScaffoldWithBottomNavigationBarState();
}

class _ScaffoldWithBottomNavigationBarState
    extends State<ScaffoldWithBottomNavigationBar> {
  // Local authentication service

  final LocalAuthService local = LocalAuthService();
  void isAuthenticate() async {
    if (!await local.authenticateWithBiometrics(context)) {
      return SystemNavigator.pop();
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    isAuthenticate();
    // Reset the authentication status when the app is resumed from the recent view
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        isAuthenticate();
      }
      return null;
    });
  }

  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(uid: uid),
    );
  }
}
