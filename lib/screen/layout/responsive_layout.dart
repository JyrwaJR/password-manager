import 'package:flutter/material.dart';
import 'package:password_manager/screen/loader/loader.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1200) {
          return const Center(child: Text("App not support"));
        } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
          return const Center(child: Text("App not support"));
        } else {
          return const Loader();
        }
      },
    );
  }
}
