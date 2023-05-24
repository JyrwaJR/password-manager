import 'package:flutter/material.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Go to Home Screen'),
          ),
          const Center(
            child: Text(
              'Password Screen',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
