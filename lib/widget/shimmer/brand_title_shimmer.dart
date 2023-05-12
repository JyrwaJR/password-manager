import 'package:flutter/material.dart';

class BrandTitleShimmer extends StatelessWidget {
  const BrandTitleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 20,
          width: 200,
          decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(12)),
        ),
        CircleAvatar(
          radius: 34,
          backgroundColor: Theme.of(context).highlightColor,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).cardColor,
          ),
        )
      ],
    );
  }
}
