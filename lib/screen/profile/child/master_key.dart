import 'package:flutter/material.dart';

class MasterKey extends StatefulWidget {
  const MasterKey({super.key});

  @override
  State<MasterKey> createState() => _MasterKeyState();
}

class _MasterKeyState extends State<MasterKey> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Key'),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            'Sorry, this feature is not available yet',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
              fontWeight: Theme.of(context).textTheme.headlineLarge?.fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
