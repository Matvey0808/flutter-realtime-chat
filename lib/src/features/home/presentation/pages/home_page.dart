import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_realtime_chat/src/features/chat/services/api_service.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/bloc/room_cubit.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/widgets/chat_card_widget.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/widgets/person_add_dialog_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final ApiService _apiService = ApiService("user-alice-id");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomCubit(_apiService),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black26,
              title: Text(
                "Chats",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
            ),
            body: BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return ChatCardWidget();
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black26,
              elevation: 0,
              highlightElevation: 0,
              onPressed: () {
                final cubit = context.read<RoomCubit>();
                showDialogPersonAdd(context, cubit);
              },
              child: Icon(Icons.person, size: 26, color: Colors.white),
            ),
          );
        }
      ),
    );
  }
}
