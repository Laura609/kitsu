import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/courses/lesson_action_button.dart';
import 'package:test1/Widgets/courses/lesson_card_widget.dart';
import 'package:test1/Widgets/courses/streak_manager.dart';
import 'package:test1/Widgets/loading_widget.dart';

class CourseLessonWidget extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;
  final String lessonContent;
  final String nextLessonId;
  final String groupId;
  final VoidCallback? onLessonCompleted;

  const CourseLessonWidget({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonContent,
    required this.nextLessonId,
    required this.groupId,
    this.onLessonCompleted,
  });

  @override
  CourseLessonWidgetState createState() => CourseLessonWidgetState();
}

class CourseLessonWidgetState extends State<CourseLessonWidget> {
  bool _lessonCompleted = false;
  bool _isLoading = true;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // Инициализация и проверка завершённости урока
  Future<void> _initialize() async {
    await _checkLessonCompletion();
    setState(() => _isLoading = false);
  }

  // Проверка, завершён ли урок
  Future<void> _checkLessonCompletion() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) return;

      final userDoc = await _getUserDoc(currentUser.email!);
      if (userDoc == null || !userDoc.exists) return;

      final completedLessonsSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .collection('completedLessons')
          .doc('${widget.groupId}_${widget.lessonId}')
          .get();

      if (completedLessonsSnapshot.exists) {
        setState(() => _lessonCompleted = true);
      }
    } catch (e) {
      logger.e("Error checking lesson completion: $e");
    }
  }

  // Получение документа пользователя
  Future<DocumentSnapshot?> _getUserDoc(String email) async {
    return FirebaseFirestore.instance.collection('Users').doc(email).get();
  }

  // Обновление прогресса
  Future<void> _updateProgress() async {
    if (_lessonCompleted) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) return;

      final userDoc = await _getUserDoc(currentUser.email!);
      if (userDoc == null || !userDoc.exists) {
        await _initializeUser(currentUser.email!);
      }

      final completedLessonsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .collection('completedLessons');

      final lessonKey = '${widget.groupId}_${widget.lessonId}';
      final completedLessonsSnapshot =
          await completedLessonsRef.doc(lessonKey).get();

      if (completedLessonsSnapshot.exists) {
        setState(() => _lessonCompleted = true);
        return;
      }

      await completedLessonsRef.doc(lessonKey).set({
        'lessonTitle': widget.lessonTitle,
        'groupId': widget.groupId,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Обновляем стрик
      await StreakManager.updateStreak(currentUser.email!); // Обновляем стрик

      // Обновляем прогресс пользователя
      await _updateUserProgress(currentUser.email!);

      setState(() => _lessonCompleted = true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Урок завершён!')),
        );

        // Вызываем callback, если он передан
        if (widget.onLessonCompleted != null) {
          widget.onLessonCompleted!();
        }
      }
    } catch (e) {
      logger.e("Error updating progress: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при завершении урока')),
        );
      }
    }
  }

// Go to next lesson
  Future<void> _goToNextLesson(BuildContext context) async {
    try {
      final lessonsInGroup = await _getLessonsInGroup(widget.groupId);
      final currentLessonIndex = lessonsInGroup
          .indexWhere((lesson) => lesson['lessonId'] == widget.lessonId);

      String nextLessonId;
      if (currentLessonIndex == lessonsInGroup.length - 1) {
        final nextGroupId = _getNextGroupId(widget.groupId);
        if (nextGroupId != null) {
          final nextLessonData =
              await _getNextLessonData(nextGroupId, 'lesson_1');
          nextLessonId = 'lesson_1';
          _navigateToNextLesson(
              context, nextLessonData, nextGroupId, nextLessonId);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Поздравляем, вы завершили курс!')),
            );
          }
        }
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

  // Обновление прогресса пользователя
  Future<void> _updateUserProgress(String email) async {
    final allLessons = await _getAllLessons();
    final totalLessons = allLessons.length;

    final completedLessonsSnapshotAll = await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('completedLessons')
        .get();

    final completedLessonsCount = completedLessonsSnapshotAll.docs.length;

    final newProgress = ((completedLessonsCount / totalLessons) * 100).toInt();

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .update({'progress': newProgress});
  }

  // Инициализация пользователя
  Future<void> _initializeUser(String email) async {
    await FirebaseFirestore.instance.collection('Users').doc(email).set({
      'progress': 0,
      'streakCount': 0,
      'lastActiveDate': null,
    });
  }

  // Получение всех уроков
  Future<List<Map<String, dynamic>>> _getAllLessons() async {
    List<Map<String, dynamic>> allLessons = [];
    final groupIds = ['group_1', 'group_2', 'group_3', 'group_4'];

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

  // Получение уроков в группе
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

  // Получение данных следующего урока
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

  // Навигация к следующему уроку
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
          onLessonCompleted: widget.onLessonCompleted, // Передаем callback
        ),
      ),
    );
  }

  // Функция для получения ID следующей группы
  String? _getNextGroupId(String currentGroupId) {
    switch (currentGroupId) {
      case 'group_1':
        return 'group_2';
      case 'group_2':
        return 'group_3';
      case 'group_3':
        return 'group_4';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: widget.lessonTitle,
        isBack: true,
        showSignOutButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LessonCard(
                lessonTitle: widget.lessonTitle,
                lessonContent: widget.lessonContent,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: LoadingWidget())
                  : LessonActionButton(
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
