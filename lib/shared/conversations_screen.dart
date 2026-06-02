import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../utils/app_theme.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final convs = context.watch<ChatProvider>().conversationList;

    return Scaffold(
      appBar: AppBar(title: const Text('च्याट')),
      body: convs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: Color(0xFFD1D5DB)),
                  SizedBox(height: 16),
                  Text('कुनै च्याट छैन',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark)),
                  SizedBox(height: 8),
                  Text('घर मालिकसँग च्याट गर्न कोठा detail मा जानुहोस्',
                      style: TextStyle(color: AppTheme.textGrey),
                      textAlign: TextAlign.center),
                ],
              ),
            )
          : ListView.separated(
              itemCount: convs.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (_, i) {
                final conv = convs[i];
                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatScreen(conversation: conv)),
                  ),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundImage:
                            NetworkImage(conv.otherUserImage),
                        backgroundColor: const Color(0xFFE5E7EB),
                      ),
                      if (conv.unreadCount > 0)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryRed,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${conv.unreadCount}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(conv.otherUserName,
                      style: TextStyle(
                          fontWeight: conv.unreadCount > 0
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conv.roomTitle,
                          style: const TextStyle(
                              fontSize: 11, color: AppTheme.primaryRed),
                          overflow: TextOverflow.ellipsis),
                      Text(conv.lastMessage,
                          style: TextStyle(
                              fontSize: 12,
                              color: conv.unreadCount > 0
                                  ? AppTheme.textDark
                                  : AppTheme.textGrey),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_formatTime(conv.lastMessageTime),
                          style: TextStyle(
                              fontSize: 10,
                              color: conv.unreadCount > 0
                                  ? AppTheme.primaryRed
                                  : AppTheme.textGrey)),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day) {
      final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    }
    return '${dt.month}/${dt.day}';
  }
}