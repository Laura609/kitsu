import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/profile_cards/profile_card.dart';
import 'package:test1/Widgets/shimer_profile_widget.dart';

class SkillWidget extends StatelessWidget {
  final String text;
  final String email;

  const SkillWidget({
    super.key,
    required this.text,
    required this.email,
  });

  Future<String?> _getSelectedSkill() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();
      return userDoc.exists ? userDoc['selected_skill'] as String? : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _showSkillDialog(BuildContext context) async {
    String? selectedSkill;
    final List<String> skills = [
      'Программирование',
      'Веб-разработка',
      'Дизайн'
    ];
    final Map<String, String> skillAbbreviations = {
      'Программирование': 'DEV',
      'Веб-разработка': 'WEB',
      'Дизайн': 'DES',
    };

    await showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок с градиентом
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF02D9AD),
                        Color(0xFF02A9D9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Text(
                    'Выберите навык',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Список навыков
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: skills.length,
                    itemBuilder: (context, index) {
                      final skill = skills[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            selectedSkill = skill;
                            Navigator.pop(context);
                          },
                          splashColor: const Color.fromRGBO(2, 217, 173, 0.2),
                          highlightColor:
                              const Color.fromRGBO(2, 217, 173, 0.1),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: const Color(0xFF02D9AD),
                                  size: 24,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  skill,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Кнопка отмены
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedSkill != null && context.mounted) {
      try {
        await FirebaseFirestore.instance.collection('Users').doc(email).update({
          'selected_skill': skillAbbreviations[selectedSkill] ?? selectedSkill,
        });
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка обновления: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.3;
    final containerHeight = size.height * 0.16;

    return FutureBuilder<String?>(
      future: _getSelectedSkill(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerCard(width: containerWidth, height: containerHeight);
        }

        return GestureDetector(
          onTap: () => _showSkillDialog(context),
          child: ProfileCard(
            icon: Icons.school_rounded,
            title: snapshot.data ?? 'Не выбрано',
            subtitle: text,
            containerWidth: containerWidth,
            containerHeight: containerHeight,
          ),
        );
      },
    );
  }
}
