import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/personal_message_page.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';

class AddChatDialog extends StatefulWidget {
  const AddChatDialog({super.key});

  @override
  State<AddChatDialog> createState() => _AddChatDialogState();
}

class _AddChatDialogState extends State<AddChatDialog> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final accentColor = Color.fromRGBO(2, 217, 173, 1); // Основной акцентный цвет
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                      vertical: 4 // Добавляем внутренний отступ снизу
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
                    return const Text('Нет данных',
                        style: TextStyle(color: Colors.white));
                  }

                  // Разделяем данные на друзей и всех пользователей
                  final friendsSnapshot = snapshot.data![0];
                  final allUsersSnapshot = snapshot.data![1];

                  // Список друзей
                  final friendsList =
                      friendsSnapshot.docs.map((doc) => doc.id).toList();
                  final filteredFriends = allUsersSnapshot.docs
                      .where((doc) => friendsList.contains(doc.id))
                      .where((doc) {
                    final name = doc['first_name'] ?? doc['username'] ?? doc.id;
                    return name.toString().toLowerCase().contains(_searchQuery);
                  }).toList();

                  // Список всех пользователей (кроме текущего и друзей)
                  final otherUsers = allUsersSnapshot.docs
                      .where((doc) =>
                          doc.id != currentUser.email &&
                          !friendsList.contains(doc.id))
                      .where((doc) {
                    final name = doc['first_name'] ?? doc['username'] ?? doc.id;
                    return name.toString().toLowerCase().contains(_searchQuery);
                  }).toList();

                  // Формируем список отображения
                  final List<dynamic> displayList = [];

                  // Добавляем друзей
                  if (filteredFriends.isNotEmpty) {
                    displayList.add(const Text('Друзья',
                        style: TextStyle(color: Colors.grey)));
                    displayList.addAll(filteredFriends);
                  }

                  // Добавляем разделитель и других пользователей
                  if (otherUsers.isNotEmpty) {
                    if (displayList.isNotEmpty) {
                      displayList.add(const Divider(
                        color: Colors.grey,
                        height: 1,
                      ));
                    }
                    displayList.add(const Text('Все пользователи',
                        style: TextStyle(color: Colors.grey)));
                    displayList.addAll(otherUsers);
                  }

                  // Обработка пустого списка
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

                  return ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final item = displayList[index];

                      // Отображение заголовков разделов
                      if (item is Text) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: item,
                        );
                      }

                      // Отображение разделителей
                      if (item is Divider) {
                        return item;
                      }

                      // Отображение пользователей
                      final userDoc =
                          item as QueryDocumentSnapshot<Map<String, dynamic>>;
                      final userData = userDoc.data();
                      final userName = userData['first_name'] ??
                          userData['username'] ??
                          userDoc.id;

                      return ListTile(
                        leading: CircleAvatar(
                            child: Icon(Icons.person, color: Colors.white)),
                        title: Text(userName,
                            style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          AppNavigator.fadePush(
                            context,
                            PersonalMessagePage(
                              currentUserId: currentUser.email!,
                              otherUserId: userDoc.id,
                              otherUserEmail: userDoc.id,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
