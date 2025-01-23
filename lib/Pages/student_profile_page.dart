import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/training_page.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/text_widget.dart';

class StudentPage extends StatefulWidget {
  static const routeName = '/StudentPage';
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
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
        text: 'Профиль',
        isBack: true,
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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Ошибка загрузки данных'));
          }

          userData = snapshot.data!.data() as Map<String, dynamic>;

          if (userData == null || userData!.isEmpty) {
            return const Center(child: Text('Данные пользователя не найдены.'));
          }

          return ListView(
            children: <Widget>[
              const SizedBox(height: 50),
              _buildLogo(),
              _buildUserInfo(userData!),
              _buildTrainingPageButton(),
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
        _buildProgressWidget(userData['progress'] ?? 0.0),
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

  Widget _buildProgressWidget(dynamic progress) {
    double progressValue =
        progress is int ? progress.toDouble() : progress.toDouble();

    return Column(
      children: [
        const Text(
          'Прогресс:',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        LinearProgressIndicator(
          value: progressValue / 100,
          backgroundColor: Colors.grey[600],
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromRGBO(2, 217, 173, 1)),
        ),
        const SizedBox(height: 10),
        Text(
          '${progressValue.toStringAsFixed(2)}%',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTrainingPageButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrainingPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Перейти в обучение'),
      ),
    );
  }
}
