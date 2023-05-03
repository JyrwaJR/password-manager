import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewPassword extends StatelessWidget {
  const ViewPassword({super.key, required this.groupId});
  final String groupId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back', style: TextStyle(letterSpacing: 1)),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
