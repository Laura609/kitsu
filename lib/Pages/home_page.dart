import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/preview_profile/user_list_item_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  // Получаем навык и роль текущего пользователя
  Future<Map<String, String>> _getUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();

    final skill = userDoc.data()?['selected_skill'] ??
        ''; // Если нет навыка, то пустая строка
    final role = userDoc.data()?['role'] ?? 'Ученик'; // По умолчанию 'ученик'

    return {'skill': skill, 'role': role};
  }

  // Запрашиваем пользователей с таким же навыком и противоположной ролью
  Stream<List<Map<String, dynamic>>> _fetchUsersBySkillAndRole(
      String skill, String role) {
    final oppositeRole = role == 'Ученик' ? 'Ментор' : 'Ученик';

    return FirebaseFirestore.instance
        .collection('Users')
        .where('selected_skill', isEqualTo: skill) // Фильтруем по навыку
        .where('role',
            isEqualTo: oppositeRole) // Фильтруем по противоположной роли
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
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
        child: FutureBuilder<Map<String, String>>(
          future: _getUserData(), // Получаем навык и роль пользователя
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            }

            final skill = snapshot.data?['skill'] ?? ''; // Навык пользователя
            final role =
                snapshot.data?['role'] ?? 'Ученик'; // Роль пользователя

            // Текст, который будет отображаться перед списком пользователей
            final roleText = role == 'Ученик' ? 'Менторы' : 'Ученики';

            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _fetchUsersBySkillAndRole(skill,
                  role), // Запрашиваем пользователей с таким же навыком и противоположной ролью
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingWidget());
                }

                if (userSnapshot.hasError) {
                  return Center(child: Text('Ошибка: ${userSnapshot.error}'));
                }

                final users = userSnapshot.data ?? [];
                if (users.isEmpty) {
                  return const Center(
                      child: Text(
                          'Нет пользователей с таким навыком и противоположной ролью.'));
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            roleText, // Показываем "Менторы" или "Ученики" в зависимости от роли
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              (users.length / 2).ceil(),
                              (index) {
                                final user1 = users[index * 2];
                                final user2 = index * 2 + 1 < users.length
                                    ? users[index * 2 + 1]
                                    : null;

                                return Column(
                                  children: [
                                    UserListItem(
                                      user: user1,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileWidget(user: user1),
                                          ),
                                        );
                                      },
                                    ),
                                    if (user2 != null)
                                      UserListItem(
                                        user: user2,
                                        onTap: () {
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
