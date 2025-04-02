import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Dialogs/add_chat_dialog.dart';
import 'package:test1/Pages/Chat/repository/chat_repository.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/bottom_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  static const routeName = '/chats';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final logic = ChatRepository(currentUser.email!);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: 'Чаты',
        isBack: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: logic.getChatsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/chat.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Здесь могла быть\nтвоя история общения',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return logic.buildChatItem(snapshot.data!.docs[index], context);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(2, 217, 173, 1),
        onPressed: () {
          AppNavigator.fadeDialog(
            context,
            const AddChatDialog(),
          );
        },
        child: const Icon(
          Icons.message,
          color: Color.fromRGBO(43, 43, 43, 1),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
