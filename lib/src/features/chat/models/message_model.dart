import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class Message {
  final int id;
  final int roomId;
  final int senderId;
  final String textMessage;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.textMessage,
  });
}
