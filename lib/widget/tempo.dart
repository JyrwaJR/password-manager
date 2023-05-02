// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Tempo extends StatefulWidget {
//   const Tempo({Key? key});

//   @override
//   State<Tempo> createState() => _TempoState();
// }

// class _TempoState extends State<Tempo> {
//   onAccountSettingsTap(value) {
//     if (value == 'Profile') {
//       // TODO
//     } else if (value == 'Account Settings') {
//       // TODO
//     } else if (value == 'Change Password') {
//       // TODO
//     } else if (value == 'Master-Key') {
//       // TODO
//     } else if (value == 'Help Center') {
//       // TODO
//     } else if (value == 'Report Bug') {
//       // TODO
//     } else {
//       // TODO
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'PROFILE',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'LOGOUT',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//         automaticallyImplyLeading: false,
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: ListView(
//           children: [
//             OneProfile(uid: uid),
//             const SizedBox(height: 30),
//             Text(
//               'GENERALS',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).hintColor),
//             ),
//             const SizedBox(height: 5),
//             TwoProfile(
//               title: 'Profile',
//               onTap: onAccountSettingsTap,
//             ),
//             TwoProfile(title: 'Account Settings', onTap: onAccountSettingsTap),
//             TwoProfile(title: 'Change Password', onTap: onAccountSettingsTap),
//             TwoProfile(title: 'Master-Key', onTap: onAccountSettingsTap),
//             Text('OTHERS',
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).hintColor)),
//             TwoProfile(title: 'Help Center', onTap: onAccountSettingsTap),
//             TwoProfile(title: 'Report Bug', onTap: onAccountSettingsTap),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Alert extends StatelessWidget {
//   const Alert({
//     required this.title,
//     super.key,
//   });
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('ok'),
//         ),
//       ],
//     );
//   }
// }

// class TwoProfile extends StatelessWidget {
//   const TwoProfile({
//     required this.title,
//     required this.onTap,
//     Key? key,
//   }) : super(key: key);

//   final String title;

//   final void Function(String) onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         borderRadius: const BorderRadius.all(Radius.circular(12)),
//         onTap: () {
//           onTap(title);
//         },
//         child: SizedBox(
//           height: 70,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       letterSpacing: 1,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OneProfile extends StatelessWidget {
//   const OneProfile({
//     super.key,
//     required this.uid,
//   });

//   final String? uid;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 85,
//             backgroundColor: Theme.of(context).primaryColor,
//             child: CircleAvatar(
//               radius: 80,
//               backgroundImage:
//                   NetworkImage('https://api.multiavatar.com/$uid Bond.png'),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Harrison Jyrwa',
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             FirebaseAuth.instance.currentUser!.email!,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 18,
//               color: Theme.of(context).dividerColor,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
