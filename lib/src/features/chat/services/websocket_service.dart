import 'dart:async';
import 'dart:convert';

import 'package:flutter_realtime_chat/src/features/chat/models/message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  String? _roomId;
  String? _userId;

  final StreamController<Message> _messageStreamController = StreamController<Message>.broadcast();
  Stream<Message> get messageStream => _messageStreamController.stream;

  final StreamController<String> _errorStreamController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _errorStreamController.stream;

  final StreamController<bool> _statusConnController = StreamController<bool>.broadcast();
  Stream<bool> get statusStream => _statusConnController.stream;

  Future<void> connect(String roomId, String userId) async {
    if (_channel?.closeCode == null && _roomId == roomId && _userId == userId) {
      print("WebSocket: Failed");
      return;
    }

    await disconnect();

    _roomId = roomId;
    _userId = userId;

    final url = Uri.parse('ws://localhost:8088/ws?room_id=$roomId&user_id=$userId');
    print("WebSocket: connection to $url");

    try {
      _channel = WebSocketChannel.connect(url);

      await _channel!.ready;
      print("WebSocket: Connected success");

      _statusConnController.add(true);
      _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone
      );
    } catch (e) {
      print("WebSocket: Connection error: $e");
      _statusConnController.add(false);
      _errorStreamController.add('Failed to connect');
      _channel = null;
    }
  }

  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
      _roomId = null;
      _userId = null;
      _statusConnController.add(false);
      print("WebSocket: disconnect");
    }
  }

  void _onData(dynamic event) {
    print("WebSocket: $event");
    try {
      String messageJson;

      if (event is String) {
        messageJson = event;
      } else if (event is List<int>) {
        messageJson = String.fromCharCodes(event);
      } else {
        throw Exception("WebSocket: Failed $event");
      }

      final Map<String, dynamic> data = jsonDecode(messageJson);

      switch (data['type']) {
        case 'ready':
          print("WebSocket: ready event");
          break;
        
        case 'message.created':
          final messageData = data['message'] as Map<String, dynamic>;
          final message = Message.fromJson(messageData);
          _messageStreamController.add(message);
          break;

        case 'message.error':
          final errorMessage = data['error'] as String?;
          final messageId = data['message_id'] as String?;
          if (errorMessage != null) {
            String error = errorMessage;
            if (messageId != null) {
              error = 'Message error $messageId: $errorMessage';
            } else {
              error = 'error: $errorMessage';
            }
            _errorStreamController.add(error);
          }
          break;

        case 'typing':
          final userId = data['user_id'] as String?;
          break;

        default:
          print("WebSocket: unknown message type: ${data['type']}");
      }
    } catch (e) {
      print("WebSocket: Error $e");
      _errorStreamController.add("$e");
    }
  }

  void _onError(Object error) {
    print("WebSocket: stream error $error");
    _statusConnController.add(false);
    _errorStreamController.add('WebSocket: connection error');
  }

  void _onDone() {
    print("WebSocket: Connection closed");
    _statusConnController.add(false);
    _errorStreamController.add("connection closed");
  }

  void sendMessage(String text, {required String clientMessageId}) {
    if (_channel == null || _roomId == null || _userId == null || text.trim().isEmpty) {
      print("WebSocket: not connect or message");
      _errorStreamController.add("not connect or message text");
      return;
    }

    final messageData = {
      'type': 'message.send',
      'text': text,
      'client_message_id': clientMessageId
    };

    try {
      _channel!.sink.add(jsonEncode(messageData));
      print(clientMessageId);
    } catch (e) {
      print("error sending message: $e");
      _errorStreamController.add("Failed to send message");
    }
  }

  void dispose() {
    _messageStreamController.close();
    _errorStreamController.close();
    _statusConnController.close();
    disconnect();
  }
}