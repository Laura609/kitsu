import 'package:flutter/material.dart';
import 'package:test1/Widgets/courses/course_lesson_widget.dart';

class LessonTile extends StatelessWidget {
  final String lessonId;
  final String lessonTitle;
  final String lessonContent;

  const LessonTile({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonContent,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      title: Text(lessonTitle,
          style: const TextStyle(fontSize: 14, color: Colors.white)),
      leading:
          const Icon(Icons.insert_drive_file, size: 20, color: Colors.white),
      tileColor: const Color.fromRGBO(36, 36, 36, 1),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseLessonWidget(
              lessonId: lessonId,
              lessonTitle: lessonTitle,
              lessonContent: lessonContent,
            ),
          ),
        );
      },
    );
  }
}
