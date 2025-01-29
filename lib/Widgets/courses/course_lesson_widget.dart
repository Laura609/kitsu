import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:test1/Widgets/courses/lesson_action_button.dart';
import 'package:test1/Widgets/courses/lesson_card_widget.dart';

class CourseLessonWidget extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final String lessonContent;
  final String nextLessonId;
  final String groupId;

  const CourseLessonWidget({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonContent,
    required this.nextLessonId,
    required this.groupId,
  });

  @override
  CourseLessonWidgetState createState() => CourseLessonWidgetState();
}

class CourseLessonWidgetState extends State<CourseLessonWidget> {
  bool _lessonCompleted = false;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _checkLessonCompletion();
  }

  Future<void> _checkLessonCompletion() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await _getUserDoc(currentUser.email!);
    final completedLessons =
        (userDoc?.data() as Map<String, dynamic>)['completedLessons'] ?? [];

    if (completedLessons.contains(widget.lessonId)) {
      setState(() {
        _lessonCompleted = true;
      });
    }
  }

  Future<DocumentSnapshot?> _getUserDoc(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    return await usersCollection.doc(email).get();
  }

  Future<void> _updateProgress() async {
    if (_lessonCompleted) return;

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await _getUserDoc(currentUser.email!);

    if (userDoc == null || !userDoc.exists) {
      await _initializeUser(currentUser.email!);
    }

    final completedLessons =
        (userDoc?.data() as Map<String, dynamic>)['completedLessons'] ?? [];
    if (completedLessons.contains(widget.lessonId)) return;

    final allLessons = await _getAllLessons();
    final totalLessons = allLessons.length;
    final completedLessonsCount = completedLessons.length + 1;
    final newProgress =
        ((completedLessonsCount / totalLessons) * 100).toStringAsFixed(1);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .update({
      'progress': double.parse(newProgress),
      'completedLessons': FieldValue.arrayUnion([widget.lessonId]),
    });

    setState(() {
      _lessonCompleted = true;
    });
  }

  Future<void> _initializeUser(String email) async {
    await FirebaseFirestore.instance.collection('Users').doc(email).set({
      'progress': 0.0,
      'completedLessons': [],
    });
  }

  Future<List<Map<String, dynamic>>> _getAllLessons() async {
    List<Map<String, dynamic>> allLessons = [];
    final groupIds = ['group_1', 'group_2', 'group_3'];
    for (final groupId in groupIds) {
      final lessonsSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc('design_course')
          .collection('groups')
          .doc(groupId)
          .collection('lessons')
          .orderBy('lessonId')
          .get();

      if (lessonsSnapshot.docs.isNotEmpty) {
        allLessons
            .addAll(lessonsSnapshot.docs.map((doc) => doc.data()).toList());
      }
    }
    return allLessons;
  }

  Future<List<Map<String, dynamic>>> _getLessonsInGroup(String groupId) async {
    final lessonsSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc('design_course')
        .collection('groups')
        .doc(groupId)
        .collection('lessons')
        .orderBy('lessonId')
        .get();

    return lessonsSnapshot.docs.isNotEmpty
        ? lessonsSnapshot.docs.map((doc) => doc.data()).toList()
        : [];
  }

  Future<void> _goToNextLesson(BuildContext context) async {
    try {
      final lessonsInGroup = await _getLessonsInGroup(widget.groupId);
      final currentLessonIndex = lessonsInGroup
          .indexWhere((lesson) => lesson['lessonId'] == widget.lessonId);

      String nextLessonId;
      if (currentLessonIndex == lessonsInGroup.length - 1) {
        final nextGroupId = widget.groupId == 'group_1' ? 'group_2' : 'group_3';
        final nextLessonData =
            await _getNextLessonData(nextGroupId, 'lesson_1');
        nextLessonId = 'lesson_1'; // First lesson in next group
        _navigateToNextLesson(
            context, nextLessonData, nextGroupId, nextLessonId);
      } else {
        nextLessonId = lessonsInGroup[currentLessonIndex + 1]['lessonId'];
        final nextLessonData =
            await _getNextLessonData(widget.groupId, nextLessonId);
        _navigateToNextLesson(
            context, nextLessonData, widget.groupId, nextLessonId);
      }
    } catch (e) {
      logger.e("Ошибка при переходе к следующему уроку: $e");
    }
  }

  Future<Map<String, dynamic>> _getNextLessonData(
      String groupId, String lessonId) async {
    final lessonDoc = await FirebaseFirestore.instance
        .collection('courses')
        .doc('design_course')
        .collection('groups')
        .doc(groupId)
        .collection('lessons')
        .doc(lessonId)
        .get();

    if (lessonDoc.exists) {
      return lessonDoc.data() as Map<String, dynamic>;
    } else {
      throw Exception("Lesson not found");
    }
  }

  void _navigateToNextLesson(
      BuildContext context,
      Map<String, dynamic> nextLessonData,
      String groupId,
      String nextLessonId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CourseLessonWidget(
          lessonId: nextLessonId,
          lessonTitle: nextLessonData['title'],
          lessonContent: nextLessonData['content'],
          nextLessonId: nextLessonData['nextLessonId'] ?? '',
          groupId: groupId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LessonCard(
                  lessonTitle: widget.lessonTitle,
                  lessonContent: widget.lessonContent),
              const SizedBox(height: 20),
              LessonActionButton(
                label: _lessonCompleted ? 'Далее' : 'Завершить урок',
                onPressed: _lessonCompleted
                    ? () => _goToNextLesson(context)
                    : _updateProgress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
