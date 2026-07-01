class Message {
  final int id;
  final String roomId;
  final String senderId;
  final String textMessage;
  final String? clientMessageId;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.textMessage,
    this.clientMessageId
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      textMessage: json['text'] as String
    );
  }

  Message copyWith({
    int? id,
    String? roomId,
    String? senderId,
    String? textMessage,
    String? clientMessageId
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      textMessage: textMessage ?? this.textMessage
    );
  }
}
