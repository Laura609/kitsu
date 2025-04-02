import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/router/router.gr.dart';
import 'package:test1/Widgets/loading_widget.dart';

@RoutePage()
class MentorOrStudentProfilePage extends StatelessWidget {
  const MentorOrStudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.email == null) {
      return const Center(child: Text('Пользователь не авторизован'));
    }

    final userEmail = currentUser.email!;
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(userEmail);

    // Обновляем поле LastEntry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userDoc.get().then((doc) {
        if (doc.exists) {
          userDoc.update({'lastEntry': FieldValue.serverTimestamp()});
        } else {
          userDoc.set({
            'lastEntry': FieldValue.serverTimestamp(),
            'role': 'ученик',
          });
        }
      });
    });

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDoc.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки данных'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Данные не найдены'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final role = (userData['role'] ?? 'ученик').toString().toLowerCase();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (role == 'ментор') {
              context.router.replace(const MentorProfileRoute());
            } else {
              context.router.replace(const StudentProfileRoute());
            }
          });

          return const Center(child: LoadingWidget());
        },
      ),
    );
  }
}
