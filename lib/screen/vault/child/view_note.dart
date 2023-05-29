import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';
import 'package:password_manager/model/dto/notes_model_dto.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          NotesTitle(groupId: groupId),
          const SizedBox(height: 10),
          NotesCard(
            groupId: groupId,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final store = FirestoreService();
          final noteId = const Uuid().v1();
          await store.addNotes(
              NotesModelDTO(
                  notesId: noteId,
                  notes:
                      'In conclusion, AI has become an integral part of our lives, driving innovation and improving efficiency across various sectors. As the field continues to evolve, it is essential to ensure responsible development and deployment of AI technologies to maximize their benefits while minimizing potential risks',
                  dateCreated: DateTime.now().toIso8601String(),
                  notesName: 'Harrison',
                  title: 'What is your name'),
              groupId,
              FirebaseAuth.instance.currentUser?.uid ?? '',
              context);
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
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
