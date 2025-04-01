import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/premium_dialog.dart';
import 'package:test1/Pages/Dialogs/skill_selection_dialog.dart';
import 'package:test1/Pages/training_page.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/button_course_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/motivation_kitsu_widget.dart';
import 'package:test1/Widgets/premium_offer_widget.dart';
import 'package:test1/Widgets/preview_profile/user_list_item_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, String>>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch user data
    _userDataFuture = _getUserData(context);
  }

  // Получаем навык и роль текущего пользователя
  Future<Map<String, String>> _getUserData(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();
    final skill = userDoc.data()?['selected_skill'] ?? '';
    final role = userDoc.data()?['role'] ?? '';

    // Если навык или роль не выбраны, показываем диалоговое окно
    if (skill.isEmpty || role.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (context) => SkillSelectionDialog(
            skills: ['Программирование', 'Веб-разработка', 'Дизайн'],
            onSkillSelected: (selectedSkill) async {
              try {
                // Map of skill abbreviations
                final skillAbbreviations = {
                  'Программирование': 'DEV',
                  'Веб-разработка': 'WEB',
                  'Дизайн': 'DES',
                };
                // Get the abbreviation for the selected skill
                final skillAbbreviation =
                    skillAbbreviations[selectedSkill] ?? selectedSkill;
                // Update Firestore with the selected skill abbreviation and default role if needed
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currentUser.email)
                    .update({
                  'selected_skill': skillAbbreviation, // Store the abbreviation
                  if (role.isEmpty)
                    'role': 'Ученик', // Set default role if not already set
                });
                // After updating Firestore, refresh the page
                setState(() {
                  _userDataFuture = _getUserData(context); // Re-fetch user data
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка обновления: $e')),
                );
              }
            },
          ),
        );
      });
    }
    return {'skill': skill, 'role': role.isNotEmpty ? role : 'Ученик'};
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
          future: _userDataFuture, // Use the future to fetch user data
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
              stream: _fetchUsersBySkillAndRole(skill, role),
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
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            roleText, // Показываем "Менторы" или "Ученики"
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
                                        AppNavigator.fadePush(
                                          context,
                                          UserProfileWidget(user: user1),
                                        );
                                      },
                                    ),
                                    if (user2 != null)
                                      UserListItem(
                                        user: user2,
                                        onTap: () {
                                          AppNavigator.fadePush(
                                            context,
                                            UserProfileWidget(user: user2),
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
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            AuctionCard(
                              title: 'Дизайн',
                              assetImage: 'assets/design.png',
                              targetPage: TrainingPage(),
                              isInteractive: true,
                            ),
                            const SizedBox(width: 10),
                            AuctionCard(
                              title: 'Flutter',
                              assetImage: 'assets/flutter.png',
                              isInteractive: false,
                            ),
                            const SizedBox(width: 10),
                            AuctionCard(
                              title: 'Flet',
                              assetImage: 'assets/flet.png',
                              isInteractive: false,
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                      PremiumOfferWidget(
                        onPressed: () {
                          AppNavigator.fadeDialog(
                            context,
                            PremiumDialog(
                              onClose: () => Navigator.pop(context),
                              onPurchase: () {
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        description:
                            'Получите доступ ко всему\nконтенту на 30 дней',
                        priceText: 'ПОЛУЧИТЬ СЕЙЧАС ЗА 299Р',
                        imageAsset: 'assets/red_fox.png',
                      ),
                      const SizedBox(height: 20),
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
