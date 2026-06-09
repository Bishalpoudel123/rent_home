import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatConversation> _conversations = [];
  bool _isLoading = false;

  List<ChatConversation> get conversationList => _conversations;
  bool get isLoading => _isLoading;

  Future<void> fetchConversations(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(seconds: 1));
    _conversations = [
      ChatConversation(
        id: '1',
        otherUserId: 'user1',
        otherUserName: 'John Doe',
        lastMessage: 'Hi, is the room still available?',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
        unreadCount: 2,
      ),
      ChatConversation(
        id: '2',
        otherUserId: 'user2',
        otherUserName: 'Jane Smith',
        lastMessage: 'When can I visit the property?',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
        unreadCount: 0,
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }

  Future<List<ChatMessage>> getMessages(String conversationId, String otherUserId) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    return [
      ChatMessage(
        id: '1',
        senderId: otherUserId,
        receiverId: 'currentUser',
        message: 'Hello! I saw your property listing',
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: 'currentUser',
        receiverId: otherUserId,
        message: 'Yes, it is still available!',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: true,
      ),
    ];
  }

  Future<void> sendMessage(String conversationId, String receiverId, String message) async {
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
  }
  
  void markAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = ChatConversation(
        id: _conversations[index].id,
        otherUserId: _conversations[index].otherUserId,
        otherUserName: _conversations[index].otherUserName,
        lastMessage: _conversations[index].lastMessage,
        lastMessageTime: _conversations[index].lastMessageTime,
        unreadCount: 0,
      );
      notifyListeners();
    }
  }
}