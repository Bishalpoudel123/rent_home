import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatConversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};
  bool _isLoading = false;
  bool _isInitialized = false;

  List<ChatConversation> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> init(String userId) async {
    if (_isInitialized) return;
    _isInitialized = true;
    await fetchConversations(userId);
  }

  Future<void> fetchConversations(String userId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _conversations = [
      ChatConversation(
        id: '1',
        participantId: 'user1',
        participantName: 'राम श्रेष्ठ',
        lastMessage: 'के कोठा अझै उपलब्ध छ?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
      ),
      ChatConversation(
        id: '2',
        participantId: 'user2',
        participantName: 'सीता गिरी',
        lastMessage: 'म कहिले कोठा हेर्न आउन सक्छु?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // ✅ यो method ChatScreen मा प्रयोग हुन्छ
  Future<List<ChatMessage>> getMessages(String conversationId, String otherUserId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_messages.containsKey(conversationId)) {
      return _messages[conversationId]!;
    }

    final messages = [
      ChatMessage(
        id: '1',
        senderId: 'user1',
        receiverId: 'currentUser',
        message: 'नमस्ते! मैले तपाईंको कोठा हेरेँ',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: 'currentUser',
        receiverId: 'user1',
        message: 'हो, कोठा अझै उपलब्ध छ!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
    ];

    _messages[conversationId] = messages;
    return messages;
  }

  // ✅ यो method ChatScreen मा प्रयोग हुन्छ
  Future<void> sendMessage(String conversationId, String receiverId, String message) async {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'currentUser',
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    if (_messages.containsKey(conversationId)) {
      _messages[conversationId]!.add(newMessage);
    } else {
      _messages[conversationId] = [newMessage];
    }

    // Conversation list update
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = ChatConversation(
        id: _conversations[index].id,
        participantId: _conversations[index].participantId,
        participantName: _conversations[index].participantName,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        unreadCount: _conversations[index].unreadCount + 1,
      );
    }

    notifyListeners();
  }

  void markAsRead(String conversationId) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = ChatConversation(
        id: _conversations[index].id,
        participantId: _conversations[index].participantId,
        participantName: _conversations[index].participantName,
        lastMessage: _conversations[index].lastMessage,
        lastMessageTime: _conversations[index].lastMessageTime,
        unreadCount: 0,
      );
      notifyListeners();
    }
  }
}