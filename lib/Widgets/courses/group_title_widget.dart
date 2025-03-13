import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/courses/lesson_title_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';

class GroupTile extends StatefulWidget {
  final String groupTitle;
  final String groupId;

  const GroupTile({
    super.key,
    required this.groupTitle,
    required this.groupId,
  });

  @override
  GroupTileState createState() => GroupTileState();
}

class GroupTileState extends State<GroupTile> {
  bool _isGroupExpanded = false;
  List<String> _completedLessons = [];

  @override
  void initState() {
    super.initState();
    _loadCompletedLessons();
  }

  Future<void> _loadCompletedLessons() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    final completedLessonsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('completedLessons')
        .get();

    setState(() {
      _completedLessons =
          completedLessonsSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  // Метод для обновления списка завершённых уроков
  Future<void> _refreshCompletedLessons() async {
    await _loadCompletedLessons();
  }

  Future<bool> _isGroupCompleted(String groupId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return false;

    final lessonsSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc('design_course')
        .collection('groups')
        .doc(groupId)
        .collection('lessons')
        .get();

    final completedLessonsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .collection('completedLessons')
        .where('groupId', isEqualTo: groupId)
        .get();

    return completedLessonsSnapshot.docs.length == lessonsSnapshot.docs.length;
  }

  Future<bool> _isLessonLocked(String groupId, String lessonId) async {
    // Первый урок первой группы всегда доступен
    if (groupId == 'group_1' && lessonId == 'lesson_1') {
      return false;
    }

    // Если это первый урок в группе, проверяем, завершена ли предыдущая группа
    if (lessonId == 'lesson_1') {
      final previousGroupId = _getPreviousGroupId(groupId);
      if (previousGroupId == null) return false; // Нет предыдущей группы

      // Используем await, так как _isGroupCompleted возвращает Future<bool>
      return !(await _isGroupCompleted(previousGroupId));
    }

    // Для остальных уроков проверяем, завершён ли предыдущий урок
    final previousLessonId = _getPreviousLessonId(groupId, lessonId);
    if (previousLessonId == null) return true;

    return !_completedLessons.contains('${widget.groupId}_$previousLessonId');
  }

  String? _getPreviousGroupId(String currentGroupId) {
    switch (currentGroupId) {
      case 'group_2':
        return 'group_1';
      case 'group_3':
        return 'group_2';
      case 'group_4':
        return 'group_3';
      default:
        return null; // Нет предыдущей группы
    }
  }

  String? _getPreviousLessonId(String groupId, String lessonId) {
    final lessonNumber = int.tryParse(lessonId.split('_').last);
    if (lessonNumber == null || lessonNumber == 1) return null;

    return 'lesson_${lessonNumber - 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isGroupExpanded = !_isGroupExpanded;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(36, 36, 36, 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
              ],
            ),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                const Icon(Icons.play_circle,
                    size: 24, color: Color.fromRGBO(2, 217, 173, 1)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.groupTitle,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Icon(
                  _isGroupExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        if (_isGroupExpanded) _buildLessonMenu(),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _getLessonsWithLockStatus(
      String groupId) async {
    final lessonsSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc('design_course')
        .collection('groups')
        .doc(groupId)
        .collection('lessons')
        .get();

    List<Map<String, dynamic>> lessons = [];

    for (var lessonDoc in lessonsSnapshot.docs) {
      var lessonData = lessonDoc.data();
      String lessonId = lessonDoc.id;

      bool isLocked = await _isLessonLocked(groupId, lessonId);

      lessons.add({
        ...lessonData,
        'lessonId': lessonId,
        'isLocked': isLocked,
      });
    }

    return lessons;
  }

  Widget _buildLessonMenu() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getLessonsWithLockStatus(widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Ошибка загрузки данных уроков',
              style: TextStyle(color: Colors.white));
        }

        var lessons = snapshot.data!;

        return ListView(
          shrinkWrap: true,
          children: lessons.map((lessonData) {
            String lessonTitle =
                lessonData['title'] ?? 'Название урока не найдено';
            String lessonContent =
                lessonData['content'] ?? 'Контент урока не найден';
            String nextLessonId = lessonData['nextLessonId'] ?? '';
            String lessonId = lessonData['lessonId'];
            bool isLocked = lessonData['isLocked'];

            return LessonTile(
              lessonId: lessonId,
              lessonTitle: lessonTitle,
              lessonContent: lessonContent,
              nextLessonId: nextLessonId,
              groupId: widget.groupId,
              isLocked: isLocked,
              onLessonCompleted: _refreshCompletedLessons, // Передаем callback
            );
          }).toList(),
        );
      },
    );
  }
}
