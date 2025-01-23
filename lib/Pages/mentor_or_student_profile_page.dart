import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/mentor_profile_page.dart';
import 'package:test1/Pages/student_profile_page.dart';

class MentorOrStudentPofilePage extends StatelessWidget {
  static const routeName = '/profile';
  const MentorOrStudentPofilePage({super.key});

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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Ошибка загрузки данных'));
          }

          // Получаем данные пользователя
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = (userData['role'] ?? '').toString().toLowerCase();

          // Отладочное сообщение: показываем полученную роль
          print("User role: $role");

          // Определяем, на какую страницу перенаправить
          if (role == 'ментор') {
            // Если роль ментор, перенаправляем на MentorPage
            if (ModalRoute.of(context)?.settings.name != MentorPage.routeName) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MentorPage()),
                );
              });
            }
          } else if (role == 'ученик') {
            // Если роль ученик, перенаправляем на StudentPage
            if (ModalRoute.of(context)?.settings.name !=
                StudentPage.routeName) {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentPage()),
                );
              });
            }
          } else {
            // Если роль не ментор и не ученик, выводим ошибку
            print("Неверная роль пользователя: $role");
            return const Center(child: Text('Роль пользователя не найдена.'));
          }

          // Пока идет проверка роли, можно отображать экран загрузки
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
