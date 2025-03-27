import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test1/Pages/Questions/mentor_skill.dart';
import 'package:test1/Pages/Questions/student_skill.dart';
import 'package:test1/Pages/Routs/mentor_or_student_profile_page.dart';
import 'package:test1/Widgets/loading_widget.dart';

class SkillMentorOrStudentPage extends StatelessWidget {
  static const routeName = '/SkillMentorOrStudentPage';
  SkillMentorOrStudentPage({super.key});

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            logger.e("Ошибка загрузки данных: ${snapshot.error}");
            return const Center(
                child: Text('Произошла ошибка при загрузке данных.'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            logger.e("Нет данных для текущего пользователя.");
            return const Center(child: Text('Нет данных для отображения.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = (userData['role'] ?? '').toString().toLowerCase();
          String? selectedSkill = userData['selected_skill'];

          logger.d("User role: $role, selectedSkill: $selectedSkill");

          // Проверка на выбранный навык
          if (role == 'ментор') {
            if (selectedSkill == null || selectedSkill.isEmpty) {
              // Если выбранный навык пуст, отправляем на выбор навыка
              return MentorSkillSelectionPage();
            } else {
              // Если навык выбран, отправляем на профиль
              return MentorOrStudentProfilePage();
            }
          } else if (role == 'ученик') {
            if (selectedSkill == null || selectedSkill.isEmpty) {
              // Если выбранный навык пуст, отправляем на выбор навыка
              return StudentSkillSelectionPage();
            } else {
              // Если навык выбран, отправляем на профиль
              return MentorOrStudentProfilePage();
            }
          } else {
            logger.e("Неверная роль пользователя: $role");
            return const Center(child: Text('Роль пользователя не найдена.'));
          }
        },
      ),
    );
  }
}
