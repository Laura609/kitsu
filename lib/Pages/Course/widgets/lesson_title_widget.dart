import 'package:flutter/material.dart';
import 'package:test1/Pages/Course/widgets/course_lesson_widget.dart';

class LessonTile extends StatelessWidget {
  final String lessonId;
  final String lessonTitle;
  final String lessonContent;
  final String nextLessonId;
  final String groupId;
  final bool isLocked;
  final VoidCallback? onLessonCompleted; // Добавляем callback

  const LessonTile({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonContent,
    required this.nextLessonId,
    required this.groupId,
    required this.isLocked,
    this.onLessonCompleted, // Передаем callback
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      title: Text(lessonTitle,
          style: TextStyle(
              fontSize: 14, color: isLocked ? Colors.grey : Colors.white)),
      leading:
          const Icon(Icons.insert_drive_file, size: 20, color: Colors.white),
      trailing: isLocked
          ? const Icon(Icons.lock, size: 20, color: Colors.grey)
          : null,
      tileColor: const Color.fromRGBO(36, 36, 36, 1),
      onTap: isLocked
          ? null
          : () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseLessonWidget(
                    lessonId: lessonId,
                    lessonTitle: lessonTitle,
                    lessonContent: lessonContent,
                    nextLessonId: nextLessonId,
                    groupId: groupId,
                    onLessonCompleted: onLessonCompleted, // Передаем callback
                  ),
                ),
              );

              // Если урок завершён, обновляем состояние
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
    );
  }
}
