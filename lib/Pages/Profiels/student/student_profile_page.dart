import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/profile_cards/skill_widget.dart';
import 'package:test1/Widgets/profile_cards/streak_widget.dart';
import 'package:test1/Widgets/profile_cards/friends_widget.dart';
import 'package:test1/Widgets/progress_widget.dart';
import 'package:test1/Widgets/shimer_profile_widget.dart';
import 'package:test1/Widgets/text_widget.dart';
import 'package:test1/router/router.gr.dart';

@RoutePage()
class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final logger = Logger();
  final currentUser = FirebaseAuth.instance.currentUser;
  late final Stream<DocumentSnapshot> _userStream;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _userStream = _initializeUserStream();
  }

  Stream<DocumentSnapshot> _initializeUserStream() {
    if (currentUser?.email != null) {
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .snapshots();
    } else {
      logger.e("Current user email is null");
      return const Stream.empty();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null || currentUser!.email == null) {
      return _buildUnauthorizedView();
    }

    return Scaffold(
      appBar: const AppBarWidget(
        text: 'Профиль',
        isBack: false,
        showSignOutButton: true,
      ),
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProfileShimmer();
          }

          if (snapshot.hasError) {
            logger.e("Error loading user data: ${snapshot.error}");
            return _buildErrorView('Ошибка загрузки данных');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildErrorView('Данные пользователя не найдены');
          }

          _userData = snapshot.data!.data() as Map<String, dynamic>;
          return _buildProfileContent();
        },
      ),
      floatingActionButton: _buildSettingsButton(context),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildUnauthorizedView() {
    return const Center(
        child: Text(
      'Пользователь не авторизован',
      style: TextStyle(color: Colors.white),
    ));
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          const SizedBox(height: 30),
          _buildLogo(),
          _buildUserInfo(),
        ],
      ),
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

  Widget _buildUserInfo() {
    return Column(
      children: [
        _buildTextWidget(_userData?['username'] ?? '', 20, true),
        _buildTextWidget(_userData?['bio'] ?? '', 16, false),
        _buildRoleWidget(_userData?['role'] ?? ''),
        const SizedBox(height: 10),
        _buildProfileStatsRow(),
        _buildProgressWidget(),
      ],
    );
  }

  Widget _buildProfileStatsRow() {
    return Row(
      children: [
        Flexible(
          child: StreakWidget(
            text: 'Дней стрика',
            email: _userData?['email'] ?? currentUser!.email!,
          ),
        ),
        Flexible(
          child: SkillWidget(
            text: 'Изучаю',
            email: _userData?['email'] ?? currentUser!.email!,
          ),
        ),
        Flexible(
          child: MentorStudentFriendsWidget(
            text: 'Друзья',
            icon: Icons.people,
            email: currentUser!.email!,
            onTap: () =>
                context.pushRoute(const FriendsRoute()), // Исправленный переход
          ),
        ),
      ],
    );
  }

  Widget _buildProgressWidget() {
    return ProgressWidget(
      courseName: 'Курс по дизайну',
      icon: Icons.school,
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

  Widget _buildTextWidget(String text, double size, bool isUsername) {
    final displayText = text.isEmpty
        ? isUsername
            ? currentUser!.email ?? 'User${Random().nextInt(1000)}'
            : 'Заполните информацию о себе'
        : text;

    return Center(
      child: TextWidget(
        textTitle: displayText,
        textTitleColor: Colors.white,
        textTitleSize: size,
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showEditDialog(context),
      backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
      child: const Icon(
        Icons.settings,
        color: Color.fromRGBO(43, 43, 43, 1),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    if (_userData != null && currentUser?.email != null) {
      context.pushRoute(
        EditUserInfoDialog(
          usernameController: _usernameController,
          bioController: _bioController,
          userEmail: currentUser!.email!,
        ),
      );
    }
  }
}
