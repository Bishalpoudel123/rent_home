import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_model.dart';
import '../../providers/chat_provider.dart';
import '../../utils/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final ChatConversation conversation;
  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  static const String _myId = 'me';

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    final text = _ctrl.text.trim();
    _ctrl.clear();
    context.read<ChatProvider>().sendMessage(
          conversationId: widget.conversation.id,
          message: text,
          senderId: _myId,
          receiverId: widget.conversation.otherUserId,
          roomId: widget.conversation.roomId,
        );
    _scrollDown();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = context
        .watch<ChatProvider>()
        .getMessages(widget.conversation.id);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  NetworkImage(widget.conversation.otherUserImage),
              onBackgroundImageError: (_, __) {},
              backgroundColor: const Color(0xFFE5E7EB),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.conversation.otherUserName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(widget.conversation.roomTitle,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textGrey,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Room reference card
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryRed.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    widget.conversation.roomImage,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.home, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.conversation.roomTitle,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark)),
                      const Text('कोठाको बारेमा कुरा गर्दैहुनुहुन्छ',
                          style:
                              TextStyle(fontSize: 10, color: AppTheme.textGrey)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right,
                    size: 16, color: AppTheme.textGrey),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final msg = messages[i];
                final isMe = msg.isSentByMe(_myId);
                final showDate = i == 0 ||
                    messages[i].createdAt.day !=
                        messages[i - 1].createdAt.day;

                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _formatDate(msg.createdAt),
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.textGrey),
                        ),
                      ),
                    _buildBubble(msg, isMe),
                  ],
                );
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppTheme.textGrey),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: (_) => _send(),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                      hintStyle: const TextStyle(
                          fontSize: 13, color: AppTheme.textGrey),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundImage:
                  NetworkImage(widget.conversation.otherUserImage),
              backgroundColor: const Color(0xFFE5E7EB),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.primaryRed : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isMe
                    ? null
                    : Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    msg.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: isMe ? Colors.white : AppTheme.textDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(msg.createdAt),
                    style: TextStyle(
                      fontSize: 9,
                      color: isMe
                          ? Colors.white.withOpacity(0.7)
                          : AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day) return 'आज';
    if (dt.day == now.day - 1) return 'हिजो';
    return '${dt.year}/${dt.month}/${dt.day}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}