import 'package:flutter/material.dart';

class BrandSwitch extends StatefulWidget {
  const BrandSwitch({
    required this.length,
    required this.onLengthChanged,
    this.maxLength,
    this.minLength,
    super.key,
  });
  final int length;
  final double? maxLength;
  final double? minLength;
  final ValueChanged<int> onLengthChanged;
  @override
  State<BrandSwitch> createState() => _BrandSwitchState();
}

class _BrandSwitchState extends State<BrandSwitch> {
  late int _passwordLength;

  @override
  void initState() {
    super.initState();
    _passwordLength = widget.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Length: $_passwordLength',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.minLength != null ? widget.minLength.toString() : '8',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _passwordLength.toDouble(),
                    min: widget.minLength ?? 8,
                    max: widget.maxLength ?? 100,
                    inactiveColor: Theme.of(context).canvasColor,
                    // divisions: 55,
                    divisions: 42,
                    label: _passwordLength.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _passwordLength = value.toInt();
                        widget.onLengthChanged(_passwordLength);
                      });
                    },
                  ),
                ),
                Text(
                  // parseInt(_passwordLength).toString(),
                  widget.maxLength != null
                      ? widget.maxLength.toString()
                      : '100',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
