import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_bar_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/services/chat/chat_service.dart';

class PersonalMessagePage extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserEmail;

  const PersonalMessagePage({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserEmail,
  });

  @override
  State<PersonalMessagePage> createState() => _PersonalMessagePageState();
}

class _PersonalMessagePageState extends State<PersonalMessagePage> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot> _messagesStream;
  String? _otherUserName;
  bool _isFriend = false;

  final FocusNode _focusNode = FocusNode(); // Создайте FocusNode

  @override
  void initState() {
    super.initState();
    _messagesStream = _chatService.getMessages(
      widget.currentUserId,
      widget.otherUserId,
    );
    _loadOtherUserName();
    _checkFriendshipStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Очистка при уничтожении виджета
    super.dispose();
  }

  void _loadOtherUserName() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.otherUserEmail)
        .get();
    if (userDoc.exists) {
      setState(() {
        _otherUserName = userDoc['first_name'];
      });
    }
  }

  void _checkFriendshipStatus() async {
    final friendDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.currentUserId)
        .collection('friends')
        .doc(widget.otherUserId)
        .get();

    setState(() {
      _isFriend = friendDoc.exists;
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || !_isFriend) return;

    await _chatService.sendMessage(
      senderId: widget.currentUserId,
      receiverId: widget.otherUserId,
      message: _controller.text,
    );

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: AppBarWidget(
        text: _otherUserName ?? widget.otherUserEmail,
        isBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoadingWidget());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Начните диалог',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final isMe = doc['sender_id'] == widget.currentUserId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 250),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          padding: const EdgeInsets.fromLTRB(
                              20, 5, 20, 5), // Уменьшены отступы
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color.fromRGBO(2, 217, 173, 1)
                                : const Color.fromRGBO(238, 238, 238, 1),
                            borderRadius: isMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  )
                                : const BorderRadius.only(
                                    topRight: Radius.circular(40),
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40),
                                  ),
                          ),
                          child: Text(
                            doc['message'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(36, 36, 36, 1),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity, // Ширина всего контейнера
                decoration: BoxDecoration(
                  color: const Color.fromARGB(47, 43, 43, 43),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Сообщение',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: const Color.fromRGBO(2, 217, 173, 1),
                        onSubmitted: (_) => _sendMessage(),
                        enabled: _isFriend,
                      ),
                    ),
                    Container(
                      width: 40, // Ширина области под кнопку
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Color.fromRGBO(2, 217, 173, 1)),
                        onPressed: _isFriend
                            ? _sendMessage
                            : null, // Блокировка кнопки, если не в друзьях
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
