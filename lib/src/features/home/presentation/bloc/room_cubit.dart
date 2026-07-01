import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/user_model.dart';
import 'package:flutter_realtime_chat/src/features/chat/services/api_service.dart';
import 'package:flutter_realtime_chat/src/features/home/models/room_model.dart';

enum RoomStatus {
  initial,
  loading,
  ready,
  error,
}

class RoomState extends Equatable {
  final RoomStatus status;
  final User? alice;
  final User? bob;
  final Room? room;
  final String? error;

  const RoomState({
    this.status = RoomStatus.initial,
    this.alice,
    this.bob,
    this.room,
    this.error
  });

  RoomState copyWith({
    RoomStatus? status,
    User? alice,
    User? bob,
    Room? room,
    String? error
  }) {
    return RoomState(
      status: status ?? this.status,
      alice: alice ?? this.alice,
      bob: bob ?? this.bob,
      room: room ?? this.room,
      error: error ?? this.error
    );
  }

  @override
  List<Object?> get props => [status, alice, bob, room, error];
}

class RoomCubit extends Cubit<RoomState> {
  final ApiService _apiService;
  late final String _currentUserId;

  RoomCubit(this._apiService) : super(const RoomState()) {
    _currentUserId = "user-alice-id";
  }

  Future<void> createUsers() async {
    emit(state.copyWith(status: RoomStatus.loading));
    try {
      User alice;
      if (state.alice == null) {
        alice = await _apiService.createUser('Alice');
      } else {
        alice = state.alice!;
      }

      User bob;
      if (state.bob == null) {
        bob = await _apiService.createUser('Bob');
      } else {
        bob = state.bob!;
      }

      final room = await _apiService.createRoom(alice.id, bob.id);

      emit(state.copyWith(
        status: RoomStatus.ready,
        alice: alice,
        bob: bob,
        room: room
      ));
    } catch (e) {
      print("Error creating Alice, Bob or Room: $e");
    }
  }

  User? getUser(String currentUserId) {
    if (state.alice?.id == currentUserId && state.bob != null) return state.bob;
    if (state.bob?.id == currentUserId && state.alice != null) return state.alice;
    return null;
  }
}