import 'package:flutter/material.dart';

class BrandTextWithSwitch extends StatefulWidget {
  const BrandTextWithSwitch({
    super.key,
    required this.onChanged,
    required this.title,
  });
  final OnChanged onChanged;
  final String title;

  @override
  State<BrandTextWithSwitch> createState() => _BrandTextWithSwitchState();
}

class _BrandTextWithSwitchState extends State<BrandTextWithSwitch> {
  bool includeSymbol = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Switch(
                inactiveThumbColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor: Theme.of(context).colorScheme.onSecondary,
                value: includeSymbol,
                onChanged: (value) {
                  setState(() {
                    includeSymbol = value;
                  });
                  widget.onChanged(value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef OnChanged = void Function(bool value);
