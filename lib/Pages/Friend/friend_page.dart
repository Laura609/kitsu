import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/add_friends_dialog.dart';
import 'package:test1/Pages/Friend/repository/friend_repository.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/friend_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';

@RoutePage()
class FriendPage extends StatelessWidget {
  static const routeName = '/friends';
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = FriendRepository(); // Создаем экземпляр логики

    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: 'Друзья',
        isBack: false,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: logic.fetchFriends(), // Используем метод из логики
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final friends = snapshot.data ?? [];
          if (friends.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/friends.png'),
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Здесь пока что пусто...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendWidget(
                friend: friend,
                onRemove: () async {
                  await logic.removeFriend(
                      friend['email']); // Используем метод из логики
                },
                onTap: () {
                  AppNavigator.fadePush(
                    context,
                    UserProfileWidget(user: friend),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
        onPressed: () {
          AppNavigator.fadeDialog(
            context,
            AddFriendDialog(),
          );
        },
        child: const Icon(
          Icons.person_add,
          color: Color.fromRGBO(43, 43, 43, 1),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
