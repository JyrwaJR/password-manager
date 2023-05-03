import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
