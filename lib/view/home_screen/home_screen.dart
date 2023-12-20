import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          AuthServices().sigOut();
        },
        elevation: 0,
        tooltip: 'Message',
        splashColor: Colors.lightBlue,
        child: const Icon(
          Icons.message_rounded,
          color: Colors.white,
          size: 29,
        ),
      ),
    );
  }
}
