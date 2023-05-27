import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class BrandTitle extends StatelessWidget {
  const BrandTitle({
    required this.title,
    required this.id,
    super.key,
  });
  final String id, title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          capitalizeFirstLetter(title),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
              fontWeight: FontWeight.bold),
        ),
        id.isNotEmpty
            ? BrandCircularAvatar(id: id, radius: 32)
            : CircleAvatar(
                backgroundColor: Theme.of(context).highlightColor,
                radius: 34,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
      ],
    );
  }
}
