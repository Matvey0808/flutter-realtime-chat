import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/user_model.dart';
import 'package:flutter_realtime_chat/src/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_realtime_chat/src/features/home/models/room_model.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/bloc/room_cubit.dart';

void showDialogPersonAdd(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<RoomCubit>(),
        child: PersonAddDialogWidget(),
      );
    },
  );
}

class PersonAddDialogWidget extends StatefulWidget {
  const PersonAddDialogWidget({super.key});

  @override
  State<PersonAddDialogWidget> createState() => _PersonAddDialogWidgetState();
}

class _PersonAddDialogWidgetState extends State<PersonAddDialogWidget> {
  late final TextEditingController _aliceNameController;
  late final TextEditingController _bobNameController;

  late final RoomCubit _cubit;

  @override
  void initState() {
    super.initState();
    _aliceNameController = TextEditingController(text: "Alice");
    _bobNameController = TextEditingController(text: "Bob");

    _cubit = context.read<RoomCubit>();
  }

  @override
  void dispose() {
    _aliceNameController.dispose();
    _bobNameController.dispose();
    super.dispose();
  }

  void _navigateToChat(BuildContext context, User sender, User receiver, Room room) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
          username: receiver,
          currentUserId: sender.id
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomCubit, RoomState>(
      listener: (context, state) {
        if (state.status == RoomStatus.ready && state.alice != null && state.bob != null && state.room != null) {
          const String currentUserId = "user-alice-id";

          User? interlocutor;
          if (state.alice!.id == currentUserId) {
            interlocutor = state.bob;
          } else if (state.bob!.id == currentUserId) {
            interlocutor = state.alice;
          }
          if (interlocutor != null) {
            _navigateToChat(
              context,
              currentUserId == state.alice!.id ? state.alice! : state.bob!,
              interlocutor,
              state.room!,
            );
            Navigator.of(context).pop(); 
          }
        } else if (state.status == RoomStatus.error) {
          print("Error room");
        }
      },
      child: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          Widget content;
          if (state.status == RoomStatus.loading) {
            content = Center(child: CircularProgressIndicator());
          } else if (state.status == RoomStatus.ready && state.alice != null && state.bob != null && state.room != null) {
            content = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Users created:"),
                Text("Alice: ${state.alice?.id} (${state.alice?.name})"),
                Text("Bob: ${state.bob?.id} (${state.bob?.name})"),
                SizedBox(height: 10),
                Text("Room ID: ${state.room?.id}"),
                SizedBox(height: 20),
              ],
            );
          } else {
            content = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _aliceNameController, decoration: InputDecoration(hintText: "Alice Name")),
                SizedBox(height: 10),
                TextField(controller: _bobNameController, decoration: InputDecoration(hintText: "Bob Name")),
              ],
            );
          }

          return AlertDialog(
            title: Text("Setup Test Environment"),
            content: content,
            actions: <Widget>[
              if (state.status != RoomStatus.loading && state.status != RoomStatus.ready)
                ElevatedButton(
                  onPressed: () async {
                    final created = await _cubit.createUsers();
                  },
                  child: Text("Create Users & Room"),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      ),
    );
  }
}
