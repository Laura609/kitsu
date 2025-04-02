import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/skill_selection_dialog.dart';
import 'package:test1/Pages/Home/home_page.dart';

class HomePageRepository {
  Future<Map<String, String>> getUserData(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();
    final skill = userDoc.data()?['selected_skill'] ?? '';
    final role = userDoc.data()?['role'] ?? '';
    if (skill.isEmpty || role.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (context) => SkillSelectionDialog(
            skills: ['Программирование', 'Веб-разработка', 'Дизайн'],
            onSkillSelected: (selectedSkill) async {
              try {
                final skillAbbreviations = {
                  'Программирование': 'DEV',
                  'Веб-разработка': 'WEB',
                  'Дизайн': 'DES',
                };
                final skillAbbreviation =
                    skillAbbreviations[selectedSkill] ?? selectedSkill;
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentUser.email)
                    .update({
                  'selected_skill': skillAbbreviation,
                  if (role.isEmpty) 'role': 'Ученик',
                });
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка обновления: $e')),
                );
              }
            },
          ),
        );
      });
    }
    return {'skill': skill, 'role': role.isNotEmpty ? role : 'Ученик'};
  }

  Stream<List<Map<String, dynamic>>> fetchUsersBySkillAndRole(
      String skill, String role) {
    final oppositeRole = role == 'Ученик' ? 'Ментор' : 'Ученик';
    return FirebaseFirestore.instance
        .collection('Users')
        .where('selected_skill', isEqualTo: skill)
        .where('role', isEqualTo: oppositeRole)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
