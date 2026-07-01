import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/message_model.dart';
import 'package:flutter_realtime_chat/src/features/chat/services/websocket_service.dart';

class ChatCubit extends Cubit<List<Message>> {
  final WebSocketService _webSocketService;
  final String _currentUserId;
  final String _roomId;

  StreamSubscription<Message>? _messageSub;

  ChatCubit({
    required WebSocketService webSocketService,
    required String currentUserId,
    required String roomId
  }) : _webSocketService = webSocketService,
       _currentUserId = currentUserId,
       _roomId = roomId,
       super([]) {
        _init();
       }

  void _init() {
    _webSocketService.connect(_roomId, _currentUserId);

    _messageSub = _webSocketService.messageStream.listen((newMessage) {
      if (newMessage.roomId == _roomId) {
        _incomingMessage(newMessage);
      }
    });
  }

  void _incomingMessage(Message newMessage) {
    final exists = state.any((message) =>
      message.clientMessageId == newMessage.clientMessageId || (newMessage.id != -1 && message.id == newMessage.id)
    );

    if (!exists) {
      emit([newMessage, ...state]);
    } else {
      final updateList = state.map((message) {
        if (message.clientMessageId == newMessage.clientMessageId) {
          return newMessage;
        }
        return message;
      }).toList();
      emit(updateList);
    }
  }

  void sendMessage(String textMessage) {
    if (textMessage.isEmpty) {
      return emit(state);
    }

    final localMessageId = DateTime.now().millisecondsSinceEpoch.toString();

    final message = Message(
      id: -1,
      roomId: _roomId,
      senderId: _currentUserId,
      textMessage: textMessage,
      clientMessageId: localMessageId
    );

    emit([message, ...state]);

    _webSocketService.sendMessage(textMessage, clientMessageId: localMessageId);

    @override
    Future<void> close() {
      _messageSub?.cancel();
      _webSocketService.disconnect();
      return super.close();
    }
  }
}