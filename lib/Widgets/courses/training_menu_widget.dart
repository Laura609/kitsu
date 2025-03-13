import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/courses/group_title_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';

class TrainingMenu extends StatelessWidget {
  const TrainingMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc('design_course')
          .collection('groups')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Ошибка загрузки данных'));
        }

        var groups = snapshot.data!.docs;

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            var groupDoc = groups[index];
            var groupData = groupDoc.data() as Map<String, dynamic>;
            String groupTitle = groupData['title'] ?? 'Группа не найдена';

            return GroupTile(groupTitle: groupTitle, groupId: groupDoc.id);
          },
        );
      },
    );
  }
}
