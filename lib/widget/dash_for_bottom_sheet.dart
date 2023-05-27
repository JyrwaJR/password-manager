import 'package:flutter/material.dart';

class DashButtonForBottomSheet extends StatelessWidget {
  const DashButtonForBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Center(
        child: Container(
          height: 6,
          width: 100,
          decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
