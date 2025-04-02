import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:test1/Widgets/skill_button_widget.dart';
import 'package:test1/Widgets/text_widget.dart';
import 'package:test1/router/router.gr.dart';

@RoutePage()
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
    return skillAbbreviations[skill] ?? skill;
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

      // Переход на страницу профиля через роутер
      if (mounted) {
        context.router
            .replace(MentorOrStudentProfileRoute()); // Используем auto_route
      }
    } catch (e) {
      logger.e('Ошибка при сохранении навыка в Firestore: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 110),
            const TextWidget(
              textTitle: 'Выберите направление:',
              textTitleColor: Colors.white,
              textTitleSize: 18,
            ),
            const SizedBox(height: 110),
            ...skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SkillButton(
                  skill: skill,
                  isSelected: selectedSkill == skill,
                  onPressed: () {
                    setState(() {
                      selectedSkill = skill;
                    });
                  },
                ),
              );
            }), // Removed unnecessary .toList()
            const SizedBox(height: 110),
            // Кнопка для сохранения выбранного направления
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedSkill != null
                      ? () async {
                          await _saveSelectedSkill();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedSkill != null
                        ? const Color.fromRGBO(2, 217, 173, 1)
                        : const Color.fromRGBO(103, 103, 103, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: selectedSkill != null
                            ? const Color.fromRGBO(2, 217, 173, 1)
                            : const Color.fromRGBO(103, 103, 103, 1),
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Далее',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
