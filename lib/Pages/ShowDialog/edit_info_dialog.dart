import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserInfoDialog extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final String userEmail;

  const EditUserInfoDialog({
    super.key,
    required this.usernameController,
    required this.bioController,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Редактировать информацию',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: usernameController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Введите новое имя',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: bioController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Введите новое био',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            String newUsername = usernameController.text.trim();
            String newBio = bioController.text.trim();
            try {
              if (newUsername.isNotEmpty) {
                // Обновление имени, если оно не пустое
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userEmail)
                    .update({'username': newUsername});
              }
              if (newBio.isNotEmpty) {
                // Обновление био, если оно не пустое
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userEmail)
                    .update({'bio': newBio});
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            } catch (e) {
              // Обработка ошибок при обновлении
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Ошибка'),
                    content: Text('Не удалось обновить информацию: $e'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ок'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
