// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:test1/Pages/mentor_or_student_profile_page.dart';

// class LevelSkilsPage extends StatefulWidget {
//   final String selectedSkill;

//   const LevelSkilsPage({super.key, required this.selectedSkill});

//   @override
//   _LevelSkilsPageState createState() => _LevelSkilsPageState();
// }

// class _LevelSkilsPageState extends State<LevelSkilsPage> {
//   String? selectedLevel;

//   // Функция для отправки уровня в Firestore
//   void sendLevelToFirestore(String level) async {
//     final currentUser = FirebaseAuth.instance.currentUser!;

//     var userDoc = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUser.email)
//         .get();

//     if (userDoc.exists) {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUser.email)
//           .update({
//         'level': level,
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: Text('Выберите уровень для ${widget.selectedSkill}')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   selectedLevel = 'Начальный';
//                 });
//               },
//               child: Text('Начальный'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   selectedLevel = 'Средний';
//                 });
//               },
//               child: Text('Средний'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   selectedLevel = 'Продвинутый';
//                 });
//               },
//               child: Text('Продвинутый'),
//             ),
//             if (selectedLevel != null) ...[
//               Text('Выбранный уровень: $selectedLevel'),
//               ElevatedButton(
//                 onPressed: () {
//                   sendLevelToFirestore(selectedLevel!);
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MentorOrStudentPofilePage(),
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
