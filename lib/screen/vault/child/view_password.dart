// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:password_manager/export.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ViewPassword extends StatefulWidget {
//   const ViewPassword({
//     super.key,
//     required this.id,
//     required this.groupId,
//     required this.uid,
//   });
//   final String id;
//   final String groupId;
//   final String uid;
//   @override
//   State<ViewPassword> createState() => _ViewPasswordState();
// }

// class _ViewPasswordState extends State<ViewPassword> {
//   final store = FirestoreService();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Back'),
//       ),
//       body: StreamBuilder<PasswordModel>(
//         stream: store.getPasswordById(
//             widget.id, widget.uid, widget.groupId, context),
//         initialData: const PasswordModel(
//           groupId: '',
//           passwordId: '',
//           password: '',
//           dateCreated: '',
//           userName: '',
//           website: '',
//         ),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.hasData) {
//               final password = snapshot.data;
//               return ListView(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 children: [
//                   BrandTitle(title: 'Password', id: widget.id),
//                   const SizedBox(height: 10),
//                   BrandPasswordDisplay(
//                       password: password.userName, title: 'Your Username'),
//                   const SizedBox(height: 10),
//                   BrandPasswordDisplay(
//                       password: password.password, title: 'Your Password'),
//                   const SizedBox(height: 10),
//                   BrandPasswordDisplay(
//                       password: password.website, title: 'Website'),
//                   const SizedBox(height: 10),
//                   BrandButton(
//                       onPressed: () async {
//                         final store = FirestoreService();
//                         await store
//                             .deletePasswordById(widget.id, context)
//                             .then((value) => context.go('/'));
//                       },
//                       title: 'Delete Password'),
//                 ],
//               );
//             } else {
//               return const Center(
//                 child: Text('has data'),
//               );
//             }
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// // class ViewPasswordCard extends StatelessWidget {
// //   const ViewPasswordCard({
// //     super.key,
// //     required this.id,
// //   });
// //   final String id;
// //   @override
// //   Widget build(BuildContext context) {
// //     final _store = FirestoreService();
// //     return StreamBuilder<PasswordModel>(
// //       stream: _store.getPasswordById(id, context),
// //       initialData: const PasswordModel(
// //         groupId: '',
// //         passwordId: '',
// //         password: '',
// //         dateCreated: '',
// //         userName: '',
// //         website: '',
// //       ),
// //       builder: (BuildContext context, AsyncSnapshot snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //         if (snapshot.connectionState == ConnectionState.active) {
// //           if (snapshot.hasData) {
// //             final password = snapshot.data;
// //             return Center(
// //               child: Text(
// //                 password.passwordId,
// //               ),
// //             );
// //           } else {
// //             return const Center(child: Text('No Data Found'));
// //           }
// //         } else {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //       },
// //     );
// //   }
// // }
