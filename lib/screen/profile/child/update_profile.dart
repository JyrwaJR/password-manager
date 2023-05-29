import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  Widget build(BuildContext context) {
    final store = FirestoreService();
    return StreamBuilder<UserModel>(
      stream: store.getUserData(uid, context),
      initialData: UserModel(
        userName: '',
        email: '',
        uid: '',
        key: '',
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData || snapshot.data != null) {
            final user = snapshot.data;
            return Center(
              child: Text(
                user.userName,
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: FlutterLogo(
                    size: 50,
                  ),
                ),
                const BrandSizeBox(
                  height: 20,
                ),
                Text(
                  'Something went wrong. Please try again after sometime.',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ],
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
