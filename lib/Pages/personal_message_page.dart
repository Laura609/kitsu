import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/Widgets/app_navigator_widget.dart';
import 'package:test1/Widgets/loading_widget.dart';
import 'package:test1/Widgets/preview_profile/user_profile_widget.dart';
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
  final FocusNode _focusNode = FocusNode();

  late Stream<QuerySnapshot> _messagesStream;
  String? _otherUserName;
  String? _lastActiveDate;
  bool _isSending = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initialize();
  }

  void _initialize() {
    _messagesStream = _chatService.getMessages(
      widget.currentUserId,
      widget.otherUserId,
    );
    _loadOtherUserData();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _isMounted = false;
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOtherUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.otherUserId)
          .get();

      if (!_isMounted) return;

      if (userDoc.exists) {
        setState(() {
          _otherUserName = userDoc['username'] ?? widget.otherUserEmail;
          _lastActiveDate = _formatLastEntry(userDoc['lastEntry']);
        });
      }
    } catch (e) {
      if (_isMounted) {
        setState(() {
          _otherUserName = widget.otherUserEmail;
          _lastActiveDate = 'Недавно';
        });
      }
    }
  }

  String _formatLastEntry(dynamic lastEntry) {
    if (lastEntry == null) return 'Недавно';
    if (lastEntry is! Timestamp) return 'Недавно';

    final date = lastEntry.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 5) return 'В сети';
    if (difference.inMinutes < 1) return 'Только что';
    if (difference.inHours < 1) return '${difference.inMinutes} мин назад';
    if (difference.inDays < 1) return '${difference.inHours} ч назад';
    if (difference.inDays < 7) return '${difference.inDays} дн назад';
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || !_isMounted) return;

    _controller.clear();
    setState(() => _isSending = true);

    try {
      await _chatService.sendMessage(
        senderId: widget.currentUserId,
        receiverId: widget.otherUserId,
        message: message,
      );
    } finally {
      if (_isMounted) {
        setState(() => _isSending = false);
      }
    }

    _scrollToBottom();
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

  void _openProfile() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.otherUserId)
          .get();

      if (!_isMounted || !userDoc.exists) return;

      AppNavigator.fadePush(
        context,
        UserProfileWidget(user: userDoc.data() as Map<String, dynamic>),
      );
    } catch (e) {
      if (_isMounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить профиль')),
        );
      }
    }
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
        onTap: _openProfile,
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
          onTap: _openProfile,
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
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingWidget());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
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
