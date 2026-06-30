import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_realtime_chat/src/features/chat/models/message_model.dart';
import 'package:flutter_realtime_chat/src/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:flutter_realtime_chat/src/features/chat/presentation/widgets/message_card_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controllerMessage = TextEditingController();

    return BlocProvider(
      create: (context) {
        return ChatCubit();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: Text(
            "Пользователь",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ChatCubit, List<Message>>(
          builder: (context, state) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        final object = state[index];
                        return Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text("username"),
                                )
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: MessageCardWidget(message: object)
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: TextField(
                              controller: _controllerMessage,
                              maxLines: null,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2.5,
                                    color: Colors.black26,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 2.5,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              final cubit = context.read<ChatCubit>();
                              cubit.sendMessage(_controllerMessage.text);
                              _controllerMessage.clear();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
