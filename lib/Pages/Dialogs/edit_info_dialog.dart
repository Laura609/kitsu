import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@RoutePage()
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
      content: SingleChildScrollView(
        // Обертываем содержимое в SingleChildScrollView
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: usernameController,
              autofocus: true,
              cursorColor: accentColor,
              maxLength: 30, // Максимальное количество символов для имени
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
                counterText: '', // Скрываем счетчик символов
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioController,
              cursorColor: accentColor,
              maxLength: 150, // Максимальное количество символов для био
              maxLines: 3, // Разрешаем многострочный ввод
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
      ),
      actions: [
        TextButton(
          child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          onPressed: () =>
              context.router.pop(), // Закрываем диалог через роутер
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

              // После успешного обновления закрываем диалог
              if (context.mounted) {
                context.router.pop(); // Закрываем диалог через роутер
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
