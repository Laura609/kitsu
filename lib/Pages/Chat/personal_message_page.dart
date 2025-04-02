import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Pages/Chat/repository/personal_message_repository.dart';
import 'package:test1/Widgets/loading_widget.dart';

@RoutePage()
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
  late PersonalMessagerepository _logic;
  late ScrollController _scrollController; // Определяем ScrollController
  late StreamController<QuerySnapshot> _messagesStreamController;
  String? _otherUserName;
  String? _lastActiveDate;
  bool _isSending = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _logic = PersonalMessagerepository(
      widget.currentUserId,
      widget.otherUserId,
    );
    _scrollController = ScrollController(); // Инициализируем ScrollController
    _initialize();
  }

  void _initialize() {
    _messagesStreamController = StreamController<QuerySnapshot>();
    _messagesStreamController.addStream(_logic.getMessagesStream());
    _loadOtherUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _controller.dispose();
    _messagesStreamController.close();
    _scrollController.dispose(); // Освобождаем ScrollController
    super.dispose();
  }

  Future<void> _loadOtherUserData() async {
    final userData = await _logic.loadOtherUserData();
    if (!_isMounted) return;
    setState(() {
      _otherUserName = userData['username'] ?? widget.otherUserEmail;
      _lastActiveDate = _logic.formatLastEntry(userData['lastEntry']);
    });
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || !_isMounted) return;
    _controller.clear();
    setState(() => _isSending = true);
    try {
      await _logic.sendMessage(message);
    } finally {
      if (_isMounted) {
        setState(() => _isSending = false);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_isMounted || !_scrollController.hasClients) return;
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

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    final isMe = doc['sender_id'] == widget.currentUserId;
    final message = doc['message'] as String;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.fromLTRB(17, 5, 17, 7),
        decoration: BoxDecoration(
          color: isMe
              ? const Color.fromRGBO(2, 217, 173, 1)
              : const Color.fromRGBO(238, 238, 238, 1),
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromRGBO(36, 36, 36, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/chat_message.png',
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          const Text(
            'Здесь рождаются истории',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[850],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        behavior: HitTestBehavior.opaque, // Убираем подсветку
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                _otherUserName ?? 'Загрузка...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_lastActiveDate != null)
                Text(
                  _lastActiveDate!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque, // Убираем подсветку
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white),
                ),
                if (_lastActiveDate == 'В сети')
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(2, 217, 173, 1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(47, 43, 43, 43),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Сообщение',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                style: const TextStyle(color: Colors.white),
                cursorColor: const Color.fromRGBO(2, 217, 173, 1),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: _isSending
                  ? const CircularProgressIndicator(
                      color: Color.fromRGBO(2, 217, 173, 1),
                      strokeWidth: 2,
                    )
                  : const Icon(
                      Icons.send,
                      color: Color.fromRGBO(2, 217, 173, 1),
                    ),
              onPressed: _isSending ? null : _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingWidget());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  controller: _scrollController, // Используем ScrollController
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      _buildMessageBubble(snapshot.data!.docs[index]),
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }
}
