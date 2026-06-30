import 'package:bloc/bloc.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/message_model.dart';

class ChatCubit extends Cubit<List<Message>> {
  ChatCubit() : super([]);

  void sendMessage(String textMessage) {
    if (textMessage.isEmpty) {
      return emit(state);
    }

    final message = Message(
      id: 0,
      roomId: 0,
      senderId: 0,
      textMessage: textMessage
    );

    emit([message, ...state]);
  }
}