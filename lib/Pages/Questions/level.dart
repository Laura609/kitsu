import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test1/Pages/Auth/main_page.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/text_widget.dart';

class MentorLevelSelectionPage extends StatefulWidget {
  static const routeName = '/MentorLevelSelectionPage';

  const MentorLevelSelectionPage({super.key});

  @override
  State<MentorLevelSelectionPage> createState() =>
      _MentorLevelSelectionPageState();
}

class _MentorLevelSelectionPageState extends State<MentorLevelSelectionPage> {
  String? selectedLevel;
  bool isLoading = true; // Flag for loading state

  // Skill levels to choose from
  final List<String> levels = ['Начальный', 'Средний', 'Продвинутый'];
  final logger = Logger();

  // Method to save the selected level in Firestore
  Future<void> _saveSelectedLevel() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null && selectedLevel != null) {
      try {
        // Save the selected level in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userEmail)
            .update({'selected_level': selectedLevel});
        logger.i('Level saved to Firestore');
      } catch (e) {
        logger.e('Error saving level to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите уровень навыка'),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      ),
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userEmail) // Fetch data for the current user
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingWidget());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Ошибка загрузки данных'));
            }

            // Fetch user data
            var userDoc = snapshot.data!;
            var userData = userDoc.data() as Map<String, dynamic>;

            // Get the selected skill and level from the database
            String selectedSkill = userData['selected_skill'] ?? 'Не выбран';
            String? selectedLevelFromDB = userData['selected_level'];

            return Column(
              children: [
                const SizedBox(height: 20),
                const TextWidget(
                  textTitle: 'Выберите уровень вашего навыка',
                  textTitleColor: Colors.white,
                  textTitleSize: 18,
                ),
                const SizedBox(height: 20),
                // Display selected skill
                Text(
                  'Вы выбрали навык: $selectedSkill',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Dropdown menu for selecting the level
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(48, 48, 48, 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedLevel ?? selectedLevelFromDB,
                    hint: const Text(
                      'Выберите уровень',
                      style: TextStyle(color: Colors.grey),
                    ),
                    dropdownColor: const Color.fromRGBO(48, 48, 48, 1),
                    style: const TextStyle(color: Colors.white),
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLevel = newValue;
                      });
                    },
                    items: levels.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),

                // Button to save the selected level
                ElevatedButton(
                  onPressed: selectedLevel != null
                      ? () async {
                          // Save selected level in Firestore
                          await _saveSelectedLevel();

                          // Navigate to the main page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Сохранить',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
