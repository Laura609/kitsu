// Виджет карточки друга
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  final Map<String, dynamic> friend;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FriendWidget({
    required this.friend,
    required this.onRemove,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(50, 50, 50, 1),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          friend['username'] ?? 'Неизвестный пользователь',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
        ),
        onTap: onTap,
      ),
    );
  }
}
