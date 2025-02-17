import 'package:flutter/material.dart';

class RoleSelectionWidget extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;
  final bool isTouched;

  const RoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
    required this.isTouched,
  });

  @override
  Widget build(BuildContext context) {
    // Проверка на выбранную роль
    bool isRoleEmpty = selectedRole.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == 'Ментор'
                    ? Color.fromRGBO(2, 217, 173, 1)
                    : Colors.grey,
              ),
              onPressed: () {
                onRoleSelected('Ментор'); // Выбираем роль "Ментор"
              },
              child: const Text(
                'Ментор',
                style: TextStyle(color: Color.fromRGBO(36, 36, 36, 1)),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == 'Ученик'
                    ? Color.fromRGBO(2, 217, 173, 1)
                    : Colors.grey,
              ),
              onPressed: () {
                onRoleSelected('Ученик'); // Выбираем роль "Ученик"
              },
              child: const Text(
                'Ученик',
                style: TextStyle(color: Color.fromRGBO(36, 36, 36, 1)),
              ),
            ),
          ],
        ),
        // Если форма отправлена и роль не выбрана, показываем ошибку
        if (isTouched && isRoleEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Пожалуйста, выберите роль',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
