import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/user_list_item_widget.dart';
import 'package:test1/Widgets/user_profile_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  // Получаем роль текущего пользователя
  Future<String> _getUserRole() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();

    final role = userDoc.data()?['role'] ?? 'Ученик'; // По умолчанию 'ученик'
    return role;
  }

  // Запрашиваем пользователей с противоположной ролью
  Stream<List<Map<String, dynamic>>> _fetchUsersByRole(String role) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: role)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => doc.data()) // No need for the cast here
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        text: 'Главная страница',
        isBack: false,
      ),
      body: Container(
        color: const Color.fromRGBO(36, 36, 36, 1), // Цвет фона
        child: FutureBuilder<String>(
          future: _getUserRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            }

            final role = snapshot.data ?? 'Ученик';
            final oppositeRole = role == 'Ученик' ? 'Ментор' : 'Ученик';
            final roleText = oppositeRole == 'Ученик'
                ? 'Ученики'
                : 'Менторы'; // Текст для отображения

            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _fetchUsersByRole(oppositeRole),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (userSnapshot.hasError) {
                  return Center(child: Text('Ошибка: ${userSnapshot.error}'));
                }

                final users = userSnapshot.data ?? [];
                if (users.isEmpty) {
                  return const Center(
                      child: Text('Нет пользователей для отображения.'));
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      // Добавление текста перед прокруткой с выравниванием по левому краю
                      Align(
                        alignment:
                            Alignment.centerLeft, // Выравнивание текста слева
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            roleText, // Показываем "Ученики" или "Менторы"
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Горизонтальная прокрутка с пользователями
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              (users.length / 2)
                                  .ceil(), // Количество "пар" пользователей
                              (index) {
                                final user1 =
                                    users[index * 2]; // Первый пользователь
                                final user2 = index * 2 + 1 < users.length
                                    ? users[index * 2 +
                                        1] // Второй пользователь (если есть)
                                    : null;

                                return Column(
                                  children: [
                                    UserListItem(
                                      user: user1,
                                      onTap: () {
                                        // При нажатии можно переходить на профиль пользователя
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileWidget(user: user1),
                                          ),
                                        );
                                      },
                                    ),
                                    if (user2 !=
                                        null) // Если второй пользователь есть
                                      UserListItem(
                                        user: user2,
                                        onTap: () {
                                          // При нажатии можно переходить на профиль второго пользователя
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserProfileWidget(
                                                      user: user2),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
