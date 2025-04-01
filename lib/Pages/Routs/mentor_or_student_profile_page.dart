import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Profiels/mentor_profile_page.dart';
import 'package:test1/Pages/Profiels/student_profile_page.dart';
import 'package:test1/Widgets/loading_widget.dart';

class MentorOrStudentProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const MentorOrStudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userEmail = currentUser.email;

    // Обновляем поле LastEntry при каждом заходе
    if (userEmail != null) {
      FirebaseFirestore.instance.collection('Users').doc(userEmail).update({
        'lastEntry': FieldValue.serverTimestamp(),
      }).catchError((error) {
        log("Ошибка при обновлении LastEntry: $error");
      });
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            log("Ошибка загрузки данных: ${snapshot.error}");
            return const Center(
                child: Text('Произошла ошибка при загрузке данных.'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            log("Нет данных для текущего пользователя.");
            return const Center(child: Text('Нет данных для отображения.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = (userData['role'] ?? '').toString().toLowerCase();

          log("User role: $role");

          // Ensure the widget is still mounted before using the context
          if (role == 'ментор') {
            if (ModalRoute.of(context)?.settings.name !=
                MentorProfilePage.routeName) {
              Future.microtask(() {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MentorProfilePage()),
                  );
                }
              });
            }
          } else if (role == 'ученик') {
            if (ModalRoute.of(context)?.settings.name !=
                StudentProfilePage.routeName) {
              Future.microtask(() {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentProfilePage()),
                  );
                }
              });
            }
          } else {
            log("Неверная роль пользователя: $role");
            return const Center(child: Text('Роль пользователя не найдена.'));
          }

          return const Center(child: LoadingWidget());
        },
      ),
    );
  }
}
