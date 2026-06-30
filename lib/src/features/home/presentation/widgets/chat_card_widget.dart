import 'package:flutter/material.dart';

class ChatCardWidget extends StatelessWidget {
  const ChatCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black12,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text("username"),
            )
          ],
        ),
      ),
    );
  }
}