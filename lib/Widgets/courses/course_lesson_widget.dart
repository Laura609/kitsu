import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test1/Widgets/app_bar_widget.dart';

class CourseLessonWidget extends StatelessWidget {
  final String lessonId;
  final String lessonTitle;
  final String lessonContent;

  CourseLessonWidget({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonContent,
  });

  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  void _updateProgress() async {
    // Код обновления прогресса
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: lessonTitle,
        isBack: true,
        showSignOutButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lessonContent,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProgress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Завершить урок'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
