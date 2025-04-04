import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test1/Pages/Dialogs/edit_info_dialog.dart'
    as dialog; // Added 'as dialog'
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/profile_cards/skill_widget.dart';
import 'package:test1/Widgets/profile_cards/streak_widget.dart';
import 'package:test1/Widgets/profile_cards/friends_widget.dart';
import 'package:test1/Widgets/text_widget.dart';
import 'package:test1/router/router.gr.dart';

@RoutePage()
class MentorProfilePage extends StatefulWidget {
  static const routeName = '/MentorProfilePage';
  const MentorProfilePage({super.key});

  @override
  State<MentorProfilePage> createState() => _MentorProfilePageState();
}

class _MentorProfilePageState extends State<MentorProfilePage> {
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
            return const Center(child: LoadingWidget());
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
            // Instantiate EditUserInfoDialog using the dialog namespace
            AppNavigator.fadeDialog(
              context,
              dialog.EditUserInfoDialog(
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
        image: AssetImage('assets/rrr.png'),
        height: 150,
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
                email: userData['email'],
              ),
            ),
            Flexible(
              child: SkillWidget(
                text: 'Изучаю',
                email: userData['email'],
              ),
            ),
            Flexible(
              child: MentorStudentFriendsWidget(
                text: 'Друзья',
                icon: Icons.people,
                email: FirebaseAuth.instance.currentUser!.email!,
                onTap: () {
                  Navigator.pushNamed(context, FriendsRoute().routeName);
                },
              ),
            ),
          ],
        ),
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
}
