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
    return Dismissible(
      key: Key(friend['id'] ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
              title: const Text(
                "Удаление друга",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "Вы уверены, что хотите удалить этого друга?",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    "Отмена",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Удалить",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onRemove();
      },
      child: Card(
        color: const Color.fromRGBO(50, 50, 50, 1),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: friend['avatar'] != null
                ? ClipOval(child: Image.network(friend['avatar']))
                : const Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            friend['username'] ?? 'Неизвестный пользователь',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: friend['status'] != null
              ? Text(
                  friend['status'],
                  style: const TextStyle(color: Colors.grey),
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
