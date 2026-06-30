import 'package:flutter/material.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/message_model.dart';

class MessageCardWidget extends StatelessWidget {
  const MessageCardWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        color: Colors.black12,
        elevation: 0,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(message.textMessage),
        ),
      ),
    );
  }
}
