import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    final accentColor =
        Color.fromRGBO(2, 217, 173, 1); // Основной акцентный цвет

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
            cursorColor: accentColor,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Введите новое имя',
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: accentColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: bioController,
            cursorColor: accentColor,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Введите новое био',
              hintStyle: const TextStyle(color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: accentColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
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
          child: Text('Сохранить', style: TextStyle(color: accentColor)),
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
