import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({
    super.key,
    required this.uid,
  });
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Back'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          BrandTitle(title: 'Profile', id: uid),
        ],
      ),
    );
  }
}
