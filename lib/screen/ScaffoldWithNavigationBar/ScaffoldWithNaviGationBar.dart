import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class ScaffoldWithBottomNavigationBar extends StatefulWidget {
  final Widget child;
  // final String routeLocation;
  const ScaffoldWithBottomNavigationBar({
    required this.child,
    super.key,
    // required this.routeLocation,
  });

  @override
  State<ScaffoldWithBottomNavigationBar> createState() =>
      _ScaffoldWithBottomNavigationBarState();
}

class _ScaffoldWithBottomNavigationBarState
    extends State<ScaffoldWithBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
          // route: widget.routeLocation,
          uid: FirebaseAuth.instance.currentUser!.uid),
    );
  }
}
