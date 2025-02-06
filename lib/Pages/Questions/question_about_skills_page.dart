// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:test1/Pages/Questions/question_level_language_page.dart';

// class SkilsPage extends StatefulWidget {
//   final String? selectedSkill;

//   const SkilsPage({super.key, this.selectedSkill});

//   @override
//   State<SkilsPage> createState() => _SkilsPageState();
// }

// class _SkilsPageState extends State<SkilsPage> {
//   String? selectedSkill;

//   // Функция для отправки навыка в Firestore
//   void sendSkillToFirestore(String skill) async {
//     final currentUser = FirebaseAuth.instance.currentUser!;

//     var userDoc = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUser.email)
//         .get();

//     if (!userDoc.exists || userDoc.data()?['skills'] == null) {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUser.email)
//           .update({
//         'skills': skill,
//         'level': '', // Уровень будет добавлен позже
//       });
//     } else {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUser.email)
//           .update({
//         'skills': skill,
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Выберите навык')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   builder: (context) => SkillSelectionSheet(
//                     onSelectSkill: (skill) {
//                       setState(() {
//                         selectedSkill = skill;
//                       });
//                     },
//                   ),
//                 );
//               },
//               child: Text('Выберите навык'),
//             ),
//             if (selectedSkill != null) ...[
//               Text('Выбранный навык: $selectedSkill'),
//               ElevatedButton(
//                 onPressed: () {
//                   sendSkillToFirestore(selectedSkill!);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           LevelSkilsPage(selectedSkill: selectedSkill!),
//                     ),
//                   );
//                 },
//                 child: Text('Продолжить'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SkillSelectionSheet extends StatelessWidget {
//   final Function(String) onSelectSkill;

//   const SkillSelectionSheet({super.key, required this.onSelectSkill});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         ListTile(
//           title: Text('Дизайн'),
//           onTap: () {
//             onSelectSkill('Дизайн');
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           title: Text('Программирование'),
//           onTap: () {
//             onSelectSkill('Программирование');
//             Navigator.pop(context);
//           },
//         ),
//         ListTile(
//           title: Text('Анализ данных'),
//           onTap: () {
//             onSelectSkill('Анализ данных');
//             Navigator.pop(context);
//           },
//         ),
//       ],
//     );
//   }
// }
