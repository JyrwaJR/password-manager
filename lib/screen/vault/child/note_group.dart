import 'package:flutter/material.dart';

class NoteGroup extends StatefulWidget {
  const NoteGroup({super.key});

  @override
  State<NoteGroup> createState() => _NoteGroupState();
}

class _NoteGroupState extends State<NoteGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Note Group'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
