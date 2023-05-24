import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/model/dto/notes_model_dto.dart';
import 'package:password_manager/model/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class ViewNotes extends StatelessWidget {
  const ViewNotes({
    super.key,
    required this.groupId,
  });
  final String groupId;
  void onSelectActionButton(
      String value, String groupId, BuildContext context) async {
    if (value == '0') {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            RenameGroupBottomSheet(groupId: groupId, isPasswordGroup: false),
      );
    } else if (value == '1') {
      return;
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
              onSelectActionButton(value, groupId, context);
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          NotesTitle(groupId: groupId),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          NotesCard(
            groupId: groupId,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO Add notes
          final store = FirestoreService();
          if (groupId.isNotEmpty) {
            final noteId = const Uuid().v4();
            await store.addNotes(
              NotesModelDTO(
                notesId: noteId,
                notes: '123456789',
                dateCreated: '123456789',
                notesName: '123456789',
              ),
              groupId,
              FirebaseAuth.instance.currentUser?.uid ?? '',
              context,
            );
          }
          return;
        },
        child: const Icon(Icons.add),
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

class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    required this.groupId,
  });
  final String groupId;

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<List<NotesModel>>(
      stream: store.viewNotesGroupWithKey(groupId, uid ?? '', context),
      initialData: const [],
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            final data = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return NoteCardItems(
                  model: snapshot.data[index],
                );
              },
            );
          } else {
            return const Center(
              child: Text('Nso notes found'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class NoteCardItems extends StatelessWidget {
  const NoteCardItems({
    super.key,
    required this.model,
  });
  final NotesModel model;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        model.notesId,
      ),
    );
  }
}
