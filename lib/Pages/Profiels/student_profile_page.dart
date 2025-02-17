import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test1/Pages/ShowDialog/edit_info_dialog.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/profile_cards/skill_widget.dart';
import 'package:test1/Widgets/profile_cards/streak_widget.dart';
import 'package:test1/Widgets/profile_cards/work_widget.dart';
import 'package:test1/Widgets/progress_widget.dart';
import 'package:test1/Widgets/text_widget.dart';

class StudentProfilePage extends StatefulWidget {
  static const routeName = '/StudentProfilePage';
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final logger = Logger();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Map<String, dynamic>? userData;

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        text: 'Профиль',
        isBack: false,
        showSignOutButton: true,
      ),
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // Проверяем состояние загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            logger.e("Error: ${snapshot.error}");
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            logger.e("No data found!");
            return const Center(child: Text('Нет данных для отображения.'));
          }

          userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null || userData!.isEmpty) {
            logger.e('Данные пользователя не найдены');
            return const Center(child: Text('Данные пользователя не найдены.'));
          }

          // Выводим полученные данные для отладки
          logger.i('Полученные данные пользователя: $userData');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 30),
                _buildLogo(),
                _buildUserInfo(userData!),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userData != null) {
            // Вызываем диалоговое окно
            showDialog(
              context: context,
              builder: (context) => EditUserInfoDialog(
                usernameController: usernameController,
                bioController: bioController,
                userEmail: currentUser.email!,
              ),
            );
          }
        },
        backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
        child: const Icon(
          Icons.settings,
          color: Color.fromRGBO(43, 43, 43, 1),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildLogo() {
    return const Center(
      child: Image(
        image: AssetImage('assets/logo.png'),
        height: 100,
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> userData) {
    return Column(
      children: [
        _buildTextWidget(userData['username'], 20, true),
        _buildTextWidget(userData['bio'], 16, false),
        _buildRoleWidget(userData['role']),
        const SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: StreakWidget(
                text: 'Дней стрика',
              ),
            ),
            Flexible(
              child: SkillWidget(
                text: 'Изучаю',
              ),
            ),
            Flexible(
              child: MentorStudentCountWidget(
                text: 'Обучаете',
                icon: Icons.person,
              ),
            ),
          ],
        ),
        _buildProgressWidget(userData['progress'] ?? 0),
      ],
    );
  }

  Widget _buildRoleWidget(String role) {
    return Center(
      child: TextWidget(
        textTitle: role,
        textTitleColor: const Color.fromRGBO(2, 217, 173, 1),
        textTitleSize: 16,
      ),
    );
  }

  Widget _buildTextWidget(String? text, double size, bool isUsername) {
    if (text == null || text.isEmpty) {
      text = isUsername
          ? currentUser.email ??
              'User${Random().nextInt(1000)}' // Используем email, если имя не задано
          : 'Заполните информацию о себе';
    }
    return Center(
      child: TextWidget(
        textTitle: text,
        textTitleColor: Colors.white,
        textTitleSize: size,
      ),
    );
  }

  Widget _buildProgressWidget(dynamic progress) {
    // Преобразуем прогресс в double и ограничиваем его
    double progressValue = progress is int
        ? progress.toDouble() / 100.0 // Преобразуем проценты в дробь
        : (progress is double
            ? progress.clamp(0.0, 1.0) // Ограничиваем значение
            : 0.0);

    return Column(
      children: [
        ProgressWidget(
          courseName: 'Курс по дизайну',
          progress: progressValue, // Передаём double
          icon: Icons.school,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
