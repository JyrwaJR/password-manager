import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/export.dart';

class UnSupportScreen extends StatelessWidget {
  const UnSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'UnSupported'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text('This platform is not supported'),
          ),
          const SizedBox(
            height: 10,
          ),
          BrandButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              title: 'Exit')
        ],
      ),
    );
  }
}
