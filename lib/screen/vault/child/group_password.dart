import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_manager/export.dart';

class GroupPasswords extends StatefulWidget {
  const GroupPasswords({super.key});

  @override
  State<GroupPasswords> createState() => _GroupPasswordsState();
}

class _GroupPasswordsState extends State<GroupPasswords> {
  final store = FirestoreService();
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<GroupPassword>>(
        stream: store.getGroupPassword(uid!, context),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const PasswordCardShimmer();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return TwoGroupPassword(model: snapshot.data!);
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
            return const PasswordCardShimmer();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createGroupBottomSheet(context, true);
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class TwoGroupPassword extends StatelessWidget {
  const TwoGroupPassword({
    super.key,
    required this.model,
  });

  final List<GroupPassword> model;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 5),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () async {
            context.goNamed(
              'view group password',
              queryParameters: <String, String>{
                'groupId': model[index].groupId,
              },
            );
          },
          child: PasswordGroupCard(
            groupPassword: model[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
