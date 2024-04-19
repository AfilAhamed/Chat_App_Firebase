import 'package:chat_app/helpers/date_util.dart';
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
        ? _greenMessage(mq, context)
        : _blueMessage(mq, context);
  }

  // sender message
  Widget _blueMessage(Size mediaquery, BuildContext context) {
    if (message.readTime.isEmpty) {
      FireStoreServices().updateReadMessageStatus(message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
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
        ),
        Padding(
          padding: EdgeInsets.only(right: mediaquery.width * .04),
          child: Text(
            DateUtil()
                .getFormatedDate(context: context, time: message.sendTime),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        )
      ],
    );
  }

  // our user message
  Widget _greenMessage(Size mediaquery, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mediaquery.width * .04,
            ),
            if (message.readTime.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            Text(
              DateUtil()
                  .getFormatedDate(context: context, time: message.sendTime),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                color: const Color.fromARGB(255, 218, 255, 176)),
            margin: EdgeInsets.symmetric(
                horizontal: mediaquery.width * .04,
                vertical: mediaquery.height * .01),
            padding: EdgeInsets.all(mediaquery.width * .04),
            child: Text(
              message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
