import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return NoteCardItems(
                  model: snapshot.data[index],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
            );
          } else {
            return const Center(
              child: Text('No Data Found'),
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
  void onSelectActionButton(
    String value,
    String notesID,
    BuildContext context,
  ) async {
    if (value == '0') {
      showModalBottomSheet(
        context: context,
        builder: (context) => RenameNotesBottomSheet(
          notesId: notesID,
          uid: FirebaseAuth.instance.currentUser?.uid ?? '',
          groupId: model.groupId,
        ),
      );
    } else if (value == '1') {
      showDialog(
        context: context,
        builder: (context) => const GetApiKeyNotYetImplemented(),
      );
    } else if (value == '2') {
      await deleteNotesByIdAlertBox(
        context,
        notesID,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO Copy Note to clipboard
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BrandCircularAvatar(
                            id: model.notesId,
                            radius: 28,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            capitalizeFirstLetter(model.notesName),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontWeight,
                            ),
                          )
                        ],
                      ),
                      Text(
                        DataFormatter.formatDateFromIsoString(
                            model.dateCreated),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge?.fontSize,
                          fontWeight:
                              Theme.of(context).textTheme.bodyLarge?.fontWeight,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          model.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.fontSize,
                            fontWeight: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.fontWeight,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ExpandableText(
                          text: model.notes,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BrandCircularAvatar(id: model.notesName, radius: 12),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        model.notesId,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall?.fontSize,
                          fontWeight: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.fontWeight,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO share button
                        },
                        icon: Icon(
                          Icons.share,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (value) => onSelectActionButton(
                          value.toString(),
                          model.notesId,
                          context,
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: '0',
                            child: Text('Update Note'),
                          ),
                          const PopupMenuItem(
                            value: '1',
                            child: Text('Get Key'),
                          ),
                          const PopupMenuItem(
                            value: '2',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
