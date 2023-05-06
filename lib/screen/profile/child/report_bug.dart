import 'package:flutter/material.dart';

class ReportBug extends StatelessWidget {
  const ReportBug({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Bug'),
        automaticallyImplyLeading: true,
      ),
    );
  }
}
