import 'package:flutter/material.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/widgets/chat_card_widget.dart';
import 'package:flutter_realtime_chat/src/features/home/presentation/widgets/person_add_dialog_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Text(
          "Chats",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return ChatCardWidget();
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black26,
        elevation: 0,
        highlightElevation: 0,
        onPressed: () {
          showDialogPersonAdd(context);
        },
        child: Icon(Icons.person, size: 26, color: Colors.white),
      ),
    );
  }
}
