import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MasterKey extends StatelessWidget {
  const MasterKey({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Key'),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
