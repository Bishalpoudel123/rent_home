class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class ChatConversation {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatConversation({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}