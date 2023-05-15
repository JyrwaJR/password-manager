import 'package:flutter/cupertino.dart';
import 'package:password_manager/constant/export_constant.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      capitalizeFirstLetter(title),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
    );
  }
}
