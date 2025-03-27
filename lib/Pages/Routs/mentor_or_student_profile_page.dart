import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Profiels/mentor_profile_page.dart';
import 'package:test1/Pages/Profiels/student_profile_page.dart';
import 'package:logger/logger.dart';
import 'package:test1/Widgets/loading_widget.dart';

class MentorOrStudentProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  MentorOrStudentProfilePage({super.key});

  final logger = Logger(); // Создание экземпляра логера

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
            // Печать ошибки для диагностики
            logger.e("Ошибка загрузки данных: ${snapshot.error}");
            return const Center(
                child: Text('Произошла ошибка при загрузке данных.'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            // Печать, если данных нет
            logger.e("Нет данных для текущего пользователя.");
            return const Center(child: Text('Нет данных для отображения.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = (userData['role'] ?? '').toString().toLowerCase();

          logger.d("User role: $role");

          if (role == 'ментор') {
            if (ModalRoute.of(context)?.settings.name !=
                MentorProfilePage.routeName) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MentorProfilePage()),
                );
              });
            }
          } else if (role == 'ученик') {
            if (ModalRoute.of(context)?.settings.name !=
                StudentProfilePage.routeName) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentProfilePage()),
                );
              });
            }
          } else {
            logger.e("Неверная роль пользователя: $role");
            return const Center(child: Text('Роль пользователя не найдена.'));
          }

          return const Center(child: LoadingWidget());
        },
      ),
    );
  }
}
