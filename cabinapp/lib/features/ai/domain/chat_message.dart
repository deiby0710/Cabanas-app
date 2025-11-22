class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.createdAt,
  });
}