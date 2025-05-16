class Conversation {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final String userId;

  Conversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp.toIso8601String(),
      'userId': userId,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp:
          DateTime.parse(json['lastMessageTimestamp'] as String),
      userId: json['userId'] as String,
    );
  }
}
