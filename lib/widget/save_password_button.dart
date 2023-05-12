import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class SavePasswordButton extends StatelessWidget {
  const SavePasswordButton({
    super.key,
    required this.onPressed,
    required this.title,
  });
  final String title;
  final OnChangedCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.2,
            child: IconButton(
                onPressed: onPressed,
                icon: Column(children: [
                  Icon(Icons.cloud_upload_outlined,
                      color: Theme.of(context).primaryColor),
                  Text(title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize:
                              Theme.of(context).textTheme.labelLarge?.fontSize,
                          fontWeight: FontWeight.bold)),
                ]))));
  }
}
