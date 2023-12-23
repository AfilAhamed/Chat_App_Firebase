import 'package:chat_app/model/user_model.dart';
import 'package:flutter/material.dart';

class ChatUserCardWidget extends StatelessWidget {
  const ChatUserCardWidget({super.key, required this.userModel});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),
          title: Text('user'),
          subtitle: Text('good morning'),
          trailing: Text(
            '12.00 Pm',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
