import 'package:flutter_realtime_chat/src/features/chat/models/message_model.dart';
import 'package:flutter_realtime_chat/src/features/home/models/room_model.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {
  final String _baseUrl = 'http://localhost:8088';
  final String _currentUserId;

  ApiService(this._currentUserId);

  Future<User> createUser(String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'name': name})
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }

  Future<Room> createRoom(String userAId, String userBId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/rooms/direct'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_a_id': userAId,
        'user_b_id': userBId
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Room.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create room: ${response.statusCode}');
    }
  }

  Future<List<Message>> getRoomMessages(String roomId, {int limit = 50}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/rooms/$roomId/messages/?user_id=$_currentUserId&limit=$limit'),
      headers: {'Accept': 'application/json'}
    );

    if (response.statusCode == 200) {
      final List<dynamic> messageList = jsonDecode(response.body);
      return messageList.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get room messages: ${response.statusCode}');
    }
  }
}