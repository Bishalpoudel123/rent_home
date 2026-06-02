import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _conversations = {};
  final List<ChatConversation> _conversationList = [];
  bool _isLoading = false;

  List<ChatConversation> get conversationList => _conversationList;
  bool get isLoading => _isLoading;

  ChatProvider() {
    _loadMockConversations();
  }

  void _loadMockConversations() {
    _conversationList.addAll([
      ChatConversation(
        id: 'conv1',
        roomId: '1',
        roomTitle: '२BHK फ्ल्याट - लजिम्पाट',
        roomImage:
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400',
        otherUserId: 'owner1',
        otherUserName: 'राम बहादुर श्रेष्ठ',
        otherUserImage:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        lastMessage: 'कोठा कहिलेदेखि available छ?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 2,
      ),
      ChatConversation(
        id: 'conv2',
        roomId: '2',
        roomTitle: 'कोठा - थमेल',
        roomImage:
            'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=400',
        otherUserId: 'owner2',
        otherUserName: 'सुनिता तामाङ',
        otherUserImage:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        lastMessage: 'हजुर, भोलि हेर्न आउन सकिन्छ',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
      ),
    ]);

    // Mock messages for conv1
    _conversations['conv1'] = [
      ChatMessage(
        id: 'm1',
        senderId: 'me',
        receiverId: 'owner1',
        roomId: '1',
        message: 'नमस्ते! कोठाको बारेमा जान्न चाहेको थिएँ।',
        type: MessageType.text,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      ChatMessage(
        id: 'm2',
        senderId: 'owner1',
        receiverId: 'me',
        roomId: '1',
        message: 'नमस्ते! के जान्न चाहनुहुन्छ?',
        type: MessageType.text,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
      ),
      ChatMessage(
        id: 'm3',
        senderId: 'me',
        receiverId: 'owner1',
        roomId: '1',
        message: 'कोठा कहिलेदेखि available छ?',
        type: MessageType.text,
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        id: 'm4',
        senderId: 'owner1',
        receiverId: 'me',
        roomId: '1',
        message: 'यही हप्तादेखि available छ। हेर्न आउनु भयो भने राम्रो हुन्थ्यो।',
        type: MessageType.text,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      ),
      ChatMessage(
        id: 'm5',
        senderId: 'owner1',
        receiverId: 'me',
        roomId: '1',
        message: 'भोलि बिहान ११ बजे आउन मिल्छ?',
        type: MessageType.text,
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 44)),
      ),
    ];
  }

  List<ChatMessage> getMessages(String conversationId) {
    return _conversations[conversationId] ?? [];
  }

  Future<void> sendMessage({
    required String conversationId,
    required String message,
    required String senderId,
    required String receiverId,
    required String roomId,
  }) async {
    final newMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      roomId: roomId,
      message: message,
      type: MessageType.text,
      isRead: false,
      createdAt: DateTime.now(),
    );

    _conversations[conversationId] ??= [];
    _conversations[conversationId]!.add(newMsg);

    // Update conversation last message
    final idx =
        _conversationList.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      final old = _conversationList[idx];
      _conversationList[idx] = ChatConversation(
        id: old.id,
        roomId: old.roomId,
        roomTitle: old.roomTitle,
        roomImage: old.roomImage,
        otherUserId: old.otherUserId,
        otherUserName: old.otherUserName,
        otherUserImage: old.otherUserImage,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        unreadCount: old.unreadCount,
      );
    }

    notifyListeners();

    // Simulate reply after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      _simulateReply(conversationId, receiverId, senderId, roomId);
    });
  }

  void _simulateReply(String convId, String from, String to, String roomId) {
    final replies = [
      'ठिकै छ, भोलि भेटौँ।',
      'राम्रो सुझाव। सोच्छु।',
      'हजुर, ठिकै छ।',
      'कति दिनका लागि चाहिन्छ?',
      'advance कति दिनुहुन्छ?',
    ];
    replies.shuffle();
    final reply = ChatMessage(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      senderId: from,
      receiverId: to,
      roomId: roomId,
      message: replies.first,
      type: MessageType.text,
      isRead: false,
      createdAt: DateTime.now(),
    );
    _conversations[convId] ??= [];
    _conversations[convId]!.add(reply);
    notifyListeners();
  }

  int get totalUnread =>
      _conversationList.fold(0, (sum, c) => sum + c.unreadCount);
}