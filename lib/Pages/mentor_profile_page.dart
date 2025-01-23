import 'package:flutter/material.dart';
import 'package:test1/Pages/training_page.dart'; // Убедитесь, что вы импортировали TrainingPage

class MentorPage extends StatefulWidget {
  static const routeName = '/MentorPage';
  const MentorPage({super.key});

  @override
  State<MentorPage> createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ментор')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTrainingPageButton(),
        ],
      ),
    );
  }

  Widget _buildTrainingPageButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrainingPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Перейти в обучение'),
      ),
    );
  }
}
