import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class NoteGroup extends StatefulWidget {
  const NoteGroup({super.key});

  @override
  State<NoteGroup> createState() => _NoteGroupState();
}

class _NoteGroupState extends State<NoteGroup> {
  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      body: StreamBuilder<List<NotesGroup>>(
        stream: store.getNotesGroup(uid, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const NoteGroupCardShimmer();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return NotesGroupCard(
                model: snapshot.data!,
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 50),
                    const BrandSizeBox(
                      height: 20,
                    ),
                    Text(
                      'Oops! No group found',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall?.fontSize,
                        fontWeight: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.fontWeight,
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const NoteGroupCardShimmer();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          createGroupBottomSheet(context, false);
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class NotesGroupCard extends StatelessWidget {
  const NotesGroupCard({
    super.key,
    required this.model,
  });
  final List<NotesGroup> model;

  void onSelectActionButton(
    String value,
    String groupId,
    BuildContext context,
  ) async {
    if (value == '0') {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            RenameGroupBottomSheet(groupId: groupId, isPasswordGroup: false),
      );
    } else if (value == '1') {
      showDialog(
        context: context,
        builder: (context) => const GetApiKeyNotYetImplemented(),
      );
    } else if (value == '2') {
      await deleteGroupWithGroupIdAlertBox(context, false, groupId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      crossAxisCount: 2,
      childAspectRatio: 4 / 5,
      children: List.generate(
        model.length,
        (index) => InkWell(
          onTap: () async {
            context.go(context.namedLocation('view notes',
                queryParameters: {'groupId': model[index].groupId}));
          },
          child: Card(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          onSelected: (value) => onSelectActionButton(
                              value, model[index].groupId, context),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: '0',
                              child: Text('Rename'),
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
                        )
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BrandCircularAvatar(
                              id: model[index].groupId, radius: 40),
                          const BrandSizeBox(height: 10),
                          Text(
                            model[index].groupName.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.fontSize,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.fontWeight,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
