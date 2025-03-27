import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/premium_dialog.dart';
import 'package:test1/Pages/training_page.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/button_course_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/motivation_kitsu_widget.dart';
import 'package:test1/Widgets/premium_offer_widget.dart';
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
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: SingleChildScrollView(
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
                  padding: const EdgeInsets.only(top: 70),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            (users.length / 2).ceil(),
                            (index) {
                              final user1 = users[index * 2];
                              final user2 = index * 2 + 1 < users.length
                                  ? users[index * 2 + 1]
                                  : null;

                              return SizedBox(
                                height: 150,
                                child: Column(
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
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MotivationKitsuWidget(onTap: () {}),
                      // TEXT
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                const TextSpan(text: 'КУРСЫ ОТ '),
                                TextSpan(
                                  text: 'KITSU',
                                  style: TextStyle(
                                    color:
                                        const Color.fromRGBO(254, 109, 142, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // КУРСЫ
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            AuctionCard(
                              title: 'Дизайн',
                              assetImage: 'assets/design.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrainingPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            AuctionCard(
                              title: 'Flutter',
                              assetImage: 'assets/flutter1.png',
                              onTap: () {},
                            ),
                            const SizedBox(width: 10),
                            AuctionCard(
                              title: 'Flet',
                              assetImage: 'assets/flet1.png',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      PremiumOfferWidget(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => PremiumDialog(
                              onClose: () => Navigator.pop(context),
                              onPurchase: () {
                                // Логика покупки
                                Navigator.pop(context);
                                // Дополнительные действия после покупки
                              },
                            ),
                            barrierDismissible: true,
                          );
                        },
                        description:
                            'Получите доступ ко всему\nконтенту на 30 дней',
                        priceText: 'ПОЛУЧИТЬ СЕЙЧАС ЗА 299Р',
                        imageAsset: 'assets/red_fox.png',
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
