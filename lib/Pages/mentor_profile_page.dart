import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/text_widget.dart';

class MentorPage extends StatefulWidget {
  static const routeName = '/MentorPage';
  const MentorPage({super.key});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  Map<String, dynamic>? userData;

  void _showSettingsDialog(Map<String, dynamic> userData) {
    usernameController.text = userData['username'] ?? '';
    bioController.text = userData['bio'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Редактировать информацию',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Введите новое имя',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Введите новое био',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Отмена', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child:
                const Text('Сохранить', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              String newUsername = usernameController.text.trim();
              String newBio = bioController.text.trim();

              if (newUsername.isNotEmpty) {
                await usersCollection
                    .doc(currentUser.email)
                    .update({'username': newUsername});
              }
              if (newBio.isNotEmpty) {
                await usersCollection
                    .doc(currentUser.email)
                    .update({'bio': newBio});
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        text: 'Менторский профиль',
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Нет данных для отображения.'));
          }

          userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null || userData!.isEmpty) {
            return const Center(child: Text('Данные пользователя не найдены.'));
          }

          return ListView(
            children: <Widget>[
              const SizedBox(height: 50),
              _buildLogo(),
              _buildUserInfo(userData!),
              _buildMentorInfo(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userData != null) {
            _showSettingsDialog(userData!);
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.settings),
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
        _buildTextWidget(userData['username'], 22, true),
        _buildTextWidget(userData['bio'], 16, false),
        _buildRoleWidget(userData['role']),
        const SizedBox(height: 20),
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
          ? 'User${Random().nextInt(1000)}'
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

  Widget _buildMentorInfo() {
    // Здесь можно добавить информацию о студентах, с которыми работает ментор
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Студенты, с которыми вы работаете:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          _buildStudentList(),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    // Пример списка студентов. Это нужно будет подключить к Firebase или другому источнику данных
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'student')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final students = snapshot.data?.docs ?? [];

        if (students.isEmpty) {
          return const Center(child: Text('Нет студентов для отображения.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: students.map((student) {
            final studentData = student.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(studentData['username'] ?? 'Без имени',
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(studentData['bio'] ?? 'Нет информации',
                  style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
        );
      },
    );
  }
}
