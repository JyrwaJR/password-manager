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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return;
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      ),
    );
  }
}
