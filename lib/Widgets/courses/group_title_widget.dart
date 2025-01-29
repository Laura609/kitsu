import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/Widgets/courses/lesson_title_widget.dart';

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
                const Icon(Icons.group, size: 24, color: Colors.white),
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

  // Метод для загрузки и отображения уроков
  Widget _buildLessonMenu() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc('design_course')
          .collection('groups')
          .doc(widget.groupId)
          .collection('lessons')
          .snapshots(),
      builder: (context, lessonsSnapshot) {
        if (lessonsSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (lessonsSnapshot.hasError || !lessonsSnapshot.hasData) {
          return const Text('Ошибка загрузки данных уроков',
              style: TextStyle(color: Colors.white));
        }

        var lessons = lessonsSnapshot.data!.docs;

        return ListView(
          shrinkWrap: true,
          children: lessons.map((lessonDoc) {
            var lessonData = lessonDoc.data() as Map<String, dynamic>;
            String lessonTitle =
                lessonData['title'] ?? 'Название урока не найдено';
            String lessonContent =
                lessonData['content'] ?? 'Контент урока не найден';
            String nextLessonId = lessonData['nextLessonId'] ?? '';

            return LessonTile(
              lessonId: lessonDoc.id,
              lessonTitle: lessonTitle,
              lessonContent: lessonContent,
              nextLessonId: nextLessonId,
              groupId: widget.groupId, // Добавляем передаваемый groupId
            );
          }).toList(),
        );
      },
    );
  }
}
