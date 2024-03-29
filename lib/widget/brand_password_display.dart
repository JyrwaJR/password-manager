import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class BrandPasswordDisplay extends StatelessWidget {
  const BrandPasswordDisplay({
    super.key,
    required this.password,
    this.title,
  });
  final String password;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (password.isNotEmpty) {
          copyToClipboard(password);
          BrandSnackbar.showSnackBar(context, 'Password copy successful');
        } else {
          BrandSnackbar.showSnackBar(context, 'Please generate a password');
        }
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'GENERATED PASSWORD',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor),
              ),
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    password.isNotEmpty ? password : 'Please Generate',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Tap here copy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                      color: Theme.of(context).hintColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
