import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

Future<dynamic> viewPasswordBottomSheet(
    BuildContext context, PasswordModel password) {
  return showModalBottomSheet(
    useRootNavigator: true,
    context: context,
    elevation: 12,
    showDragHandle: true,
    useSafeArea: true,
    isDismissible: true,
    builder: (context) => ListView(
      padding: const EdgeInsets.all(10),
      children: [
        BrandTitle(title: 'Password', id: password.passwordId),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Password ID: ${password.passwordId}',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
          ),
        ),
        const SizedBox(height: 10),
        BrandPasswordDisplay(
            password: password.userName, title: 'Your Username'),
        const SizedBox(height: 10),
        BrandPasswordDisplay(
            password: password.password, title: 'Your Password'),
        const SizedBox(height: 20),
        BrandPasswordDisplay(password: password.website, title: 'Website'),
      ],
    ),
  );
}
