import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, 
    required this.text,
    required this.maxLines,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        isExpanded
            ? Text(
                widget.text,
                maxLines: isExpanded ? null : widget.maxLines,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
                  color: Theme.of(context).hintColor,
                ),
              )
            : Text(
                widget.text,
                maxLines: widget.maxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                  fontWeight: Theme.of(context).textTheme.bodyLarge?.fontWeight,
                  color: Theme.of(context).hintColor,
                ),
              ),
        widget.text.length > 195
            ? !isExpanded
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      'Show More',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      'Show less',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
            : const SizedBox(),
      ],
    );
  }
}
