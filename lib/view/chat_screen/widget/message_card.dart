import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return FireStoreServices().auth!.uid == message.fromId
        ? _greenMessage()
        : _blueMessage(mq);
  }

  // sender message
  Widget _blueMessage(Size mediaquery) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: const Color.fromARGB(255, 221, 245, 255)),
          margin: EdgeInsets.symmetric(
              horizontal: mediaquery.width * .04,
              vertical: mediaquery.height * .01),
          padding: EdgeInsets.all(mediaquery.width * .04),
          child: Text(
            message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        Text(
          message.sendTime,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        )
      ],
    );
  }

  // our user message
  Widget _greenMessage() {
    return Container();
  }
}
