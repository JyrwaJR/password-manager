import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/model/dto/notes_model_dto.dart';
import 'package:uuid/uuid.dart';

class ViewNotes extends StatefulWidget {
  const ViewNotes({
    super.key,
    required this.groupId,
  });
  final String groupId;

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  void onSelectActionButton(
      String value, String groupId, BuildContext context) async {
    if (value == '0') {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            RenameGroupBottomSheet(groupId: groupId, isPasswordGroup: false),
      );
    } else if (value == '1') {
      showDialog(
          context: context,
          builder: (context) => const GetApiKeyNotYetImplemented());
    } else if (value == '2') {
      await deleteGroupWithGroupIdAlertBox(context, false, groupId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const AppBarTitle(title: 'Back'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              onSelectActionButton(value, widget.groupId, context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '0', child: Text('Rename')),
              const PopupMenuItem(value: '1', child: Text('Get Key')),
              const PopupMenuItem(value: '2', child: Text('Delete')),
            ],
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          NotesTitle(groupId: widget.groupId),
          const SizedBox(height: 10),
          NotesCard(
            groupId: widget.groupId,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showCupertinoDialog(
            // showDragHandle: true,
            // useSafeArea: true,
            context: context,
            builder: (context) => SaveNoteBottomSheet(groupId: widget.groupId),
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class SaveNoteBottomSheet extends StatefulWidget {
  const SaveNoteBottomSheet({
    super.key,
    required this.groupId,
  });
  final String groupId;

  @override
  State<SaveNoteBottomSheet> createState() => _SaveNoteBottomSheetState();
}

class _SaveNoteBottomSheetState extends State<SaveNoteBottomSheet> {
  String isNoteName = '';
  String isTitle = '';
  String isNotes = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(title: 'Back'),
        automaticallyImplyLeading: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            BrandTitle(title: 'Save Note', id: widget.groupId),
            const SizedBox(height: 10),
            Text(
              'A way to save your note',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                  ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter note name';
                }
                if (value.length > 20) {
                  return 'Note name must be less than 20 characters';
                }
                if (value.length < 3) {
                  return 'Note name must be more than 3 characters';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  isNoteName = value;
                });
              },
              maxLength: 20,
              decoration: const InputDecoration(
                labelText: 'Note Name',
                hintText: 'please enter your note name',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title';
                }
                if (value.length > 100) {
                  return 'Title must be less than 100 characters';
                }
                if (value.length < 3) {
                  return 'Title must be more than 3 characters';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  isTitle = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'please enter your note title',
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter note';
                }
                if (value.length < 3) {
                  return 'Note must be more than 3 characters';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  isNotes = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'please enter your note',
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 10),
            BrandButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final store = FirestoreService();
                    final notesId = const Uuid().v4();
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    await store
                        .addNotes(
                            NotesModelDTO(
                              notesId: notesId,
                              notes: isNotes,
                              dateCreated: DateTime.now().toIso8601String(),
                              notesName: isNoteName,
                              title: isTitle,
                            ),
                            widget.groupId,
                            uid ?? '',
                            context)
                        .then((value) => Navigator.pop(context));
                  }
                },
                title: 'Save'),
          ],
        ),
      ),
    );
  }
}

class NotesTitle extends StatelessWidget {
  const NotesTitle({
    super.key,
    required this.groupId,
  });
  final String groupId;
  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<NotesGroup>(
      stream: store.getNotesGroupByGroupId(groupId, uid!, context),
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BrandTitleShimmer();
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return BrandTitle(
              title: capitalizeFirstLetter(data?.groupName ?? ''),
              id: groupId,
            );
          } else {
            return const BrandTitleShimmer();
          }
        } else {
          return const BrandTitleShimmer();
        }
      },
    );
  }
}
