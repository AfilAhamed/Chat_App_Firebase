import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/view/home_screen/widgets/chat_user_card.dart';
import 'package:chat_app/view/profile_screen/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FireStoreServices().getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> list = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatApp',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              userModel: FireStoreServices.me,
                            )));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: StreamBuilder(
        stream: FireStoreServices().getAllUsers(),
        builder: (context, snapshoot) {
          final data = snapshoot.data?.docs;
          list = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
          if (snapshoot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (list.isEmpty) {
            return const Center(
              child: Text('No Chats Found'),
            );
          } else {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8.0),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ChatUserCardWidget(
                    userModel: list[index],
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {},
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
