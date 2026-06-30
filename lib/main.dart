import 'package:flutter/material.dart';
import 'package:flutter_realtime_chat/src/features/chat/presentation/pages/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurpleAccent)
      ),
      home: ChatPage()
    );
  }
}