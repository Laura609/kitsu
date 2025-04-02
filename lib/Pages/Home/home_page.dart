import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/premium_dialog.dart';
import 'package:test1/Pages/Course/course_page.dart';
import 'package:test1/Pages/Home/repository/home_page_repository.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/button_course_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/motivation_kitsu_widget.dart';
import 'package:test1/Widgets/premium_offer_widget.dart';
import 'package:test1/Widgets/preview_profile/user_list_item_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, String>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = HomePageRepository().getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, String>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            }
            final skill = snapshot.data?['skill'] ?? '';
            final role = snapshot.data?['role'] ?? 'Ученик';
            final roleText = role == 'Ученик' ? 'Менторы' : 'Ученики';
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream:
                  HomePageRepository().fetchUsersBySkillAndRole(skill, role),
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
                            roleText,
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
                              targetPage: CoursePage(),
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
                            'Получите доступ ко всему контенту на 30 дней',
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
