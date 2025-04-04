import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';

class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({super.key});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final accentColor = const Color.fromRGBO(2, 217, 173, 1);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getUserName(Map<String, dynamic>? userData, String userId) {
    if (userData == null) return userId;
    return userData['username']?.toString() ??
        userData['username']?.toString() ??
        userId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Поиск пользователей',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            // Поле поиска
            SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[850],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
                onChanged: (query) =>
                    setState(() => _searchQuery = query.toLowerCase()),
              ),
            ),

            // Список пользователей
            Expanded(
              child: FutureBuilder<List<QuerySnapshot>>(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUser.email)
                      .collection('friends')
                      .get(),
                  FirebaseFirestore.instance.collection('Users').get(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingWidget());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('Нет данных',
                          style: TextStyle(color: Colors.white)),
                    );
                  }

                  final friendsSnapshot = snapshot.data![0];
                  final allUsersSnapshot = snapshot.data![1];

                  // Список друзей
                  final friendsList =
                      friendsSnapshot.docs.map((doc) => doc.id).toList();

                  // Фильтрация пользователей
                  final filteredUsers = allUsersSnapshot.docs.where((doc) {
                    if (doc.id == currentUser.email) return false;
                    final userData = doc.data() as Map<String, dynamic>?;
                    final name = _getUserName(userData, doc.id).toLowerCase();
                    return name.contains(_searchQuery);
                  }).toList();

                  // Разделение на друзей и других пользователей
                  final filteredFriends = filteredUsers
                      .where((doc) => friendsList.contains(doc.id))
                      .toList();
                  final otherUsers = filteredUsers
                      .where((doc) => !friendsList.contains(doc.id))
                      .toList();

                  // Формирование списка для отображения
                  final List<Widget> displayList = [];

                  // Добавление друзей
                  if (filteredFriends.isNotEmpty) {
                    displayList.add(
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Друзья',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                    displayList.addAll(filteredFriends.map((doc) =>
                        _buildUserTile(doc
                            as QueryDocumentSnapshot<Map<String, dynamic>>)));
                  }

                  // Добавление других пользователей
                  if (otherUsers.isNotEmpty) {
                    if (displayList.isNotEmpty) {
                      displayList
                          .add(const Divider(color: Colors.grey, height: 1));
                    }
                    displayList.add(
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Все пользователи',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                    displayList.addAll(otherUsers.map((doc) => _buildUserTile(
                        doc as QueryDocumentSnapshot<Map<String, dynamic>>)));
                  }

                  // Пустое состояние
                  if (displayList.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.people_outline,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Ничего не найдено',
                            style: TextStyle(color: Colors.white)),
                      ],
                    );
                  }

                  return ListView(children: displayList);
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildUserTile(QueryDocumentSnapshot<Map<String, dynamic>> userDoc) {
    final userData = userDoc.data();
    final userName = _getUserName(userData, userDoc.id);

    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(userName, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        AppNavigator.fadePush(
          context,
          UserProfileWidget(user: userData),
        );
      },
    );
  }
}
