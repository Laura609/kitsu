import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:test1/Pages/mentor_or_student_profile_page.dart';
import 'package:test1/Widgets/text_widget.dart';

class StudentSkillSelectionPage extends StatefulWidget {
  static const routeName = '/StudentSkillSelectionPage';

  const StudentSkillSelectionPage({super.key});

  @override
  State<StudentSkillSelectionPage> createState() =>
      _StudentSkillSelectionPageState();
}

class _StudentSkillSelectionPageState extends State<StudentSkillSelectionPage> {
  String? selectedSkill;
  final logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Навыки для выбора
  final List<String> skills = ['Программирование', 'Веб-разработка', 'Дизайн'];

  // Маппинг направления на сокращение
  final Map<String, String> skillAbbreviations = {
    'Программирование': 'DEV',
    'Веб-разработка': 'WEB',
    'Дизайн': 'DES',
  };

  // Метод для получения сокращения навыка
  String _getSkillAbbreviation(String skill) {
    return skillAbbreviations[skill] ??
        skill; // Возвращаем сокращение или оригинальное значение
  }

  // Метод для сохранения выбранного навыка в Firestore
  Future<void> _saveSelectedSkill() async {
    final userEmail = _auth.currentUser?.email;

    if (userEmail == null) {
      logger.e('Пользователь не авторизован');
      return;
    }

    if (selectedSkill == null) {
      logger.e('Выберите направление');
      return;
    }

    try {
      final skillAbbreviation = _getSkillAbbreviation(selectedSkill!);

      // Сохраняем выбранный навык в Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmail)
          .update({'selected_skill': skillAbbreviation});

      logger.i('Навык сохранен в Firestore: $skillAbbreviation');

      // Переход на страницу профиля
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MentorOrStudentPofilePage()),
      );
    } catch (e) {
      logger.e('Ошибка при сохранении навыка в Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Что хотите изучить?'),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      ),
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const TextWidget(
              textTitle: 'Выберите направление',
              textTitleColor: Colors.white,
              textTitleSize: 18,
            ),
            const SizedBox(height: 20),
            // Выпадающее меню для выбора направления
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(48, 48, 48, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedSkill,
                hint: const Text(
                  'Направления:',
                  style: TextStyle(color: Colors.grey),
                ),
                dropdownColor: const Color.fromRGBO(48, 48, 48, 1),
                style: const TextStyle(color: Colors.white),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSkill = newValue;
                  });
                },
                items: skills.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            // Кнопка для сохранения выбранного направления
            ElevatedButton(
              onPressed: selectedSkill != null
                  ? () async {
                      await _saveSelectedSkill();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Далее',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
