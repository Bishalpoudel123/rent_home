import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.fetchConversations('currentUser');
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: chatProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : chatProvider.conversationList.isEmpty
              ? Center(child: Text('No messages yet'))
              : ListView.builder(
                  itemCount: chatProvider.conversationList.length,
                  itemBuilder: (context, index) {
                    final conv = chatProvider.conversationList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(conv.otherUserName[0]),
                      ),
                      title: Text(conv.otherUserName),
                      subtitle: Text(conv.lastMessage, maxLines: 1),
                      trailing: conv.unreadCount > 0
                          ? CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Text('${conv.unreadCount}', style: TextStyle(fontSize: 10)),
                            )
                          : null,
                      onTap: () {
                        chatProvider.markAsRead(conv.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              receiverId: conv.otherUserId,
                              receiverName: conv.otherUserName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}