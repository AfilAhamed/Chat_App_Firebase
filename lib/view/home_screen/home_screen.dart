import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/view/home_screen/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
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
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8.0),
          itemCount: 5,
          itemBuilder: (context, index) {
            return const ChatUserCardWidget();
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          provider.signOut();
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
