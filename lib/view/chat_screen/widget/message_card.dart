import 'package:cached_network_image/cached_network_image.dart';
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
    return InkWell(
        onLongPress: () {
          showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              context: context,
              builder: (builder) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 4,
                      margin: EdgeInsets.symmetric(
                          vertical: mq.height * .015,
                          horizontal: mq.width * .4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey),
                    ),
                    OptionItem(
                        icon: const Icon(
                          Icons.copy_all_outlined,
                          color: Colors.blue,
                          size: 26,
                        ),
                        name: 'Copy Text',
                        onTap: () {}),
                    Divider(
                      color: Colors.grey,
                      endIndent: mq.width * .04,
                      indent: mq.width * .04,
                    ),
                    OptionItem(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 26,
                        ),
                        name: 'Edit Message',
                        onTap: () {}),
                    OptionItem(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 26,
                        ),
                        name: 'Delete Message',
                        onTap: () {}),
                    Divider(
                      color: Colors.grey,
                      endIndent: mq.width * .04,
                      indent: mq.width * .04,
                    ),
                    OptionItem(
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.blue,
                        ),
                        name: 'Sent At',
                        onTap: () {}),
                    OptionItem(
                        icon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.green,
                        ),
                        name: 'Read At',
                        onTap: () {})
                  ],
                );
              });
        },
        child: FireStoreServices().auth!.uid == message.fromId
            ? _greenMessage(mq, context)
            : _blueMessage(mq, context));
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
            padding: EdgeInsets.all(message.type == Type.text
                ? mediaquery.width * .04
                : mediaquery.width * .03),
            child: message.type == Type.text
                ? Text(
                    message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: message.msg,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
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
            padding: EdgeInsets.all(message.type == Type.text
                ? mediaquery.width * .04
                : mediaquery.width * .03),
            child: message.type == Type.text
                ? Text(
                    message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      fit: BoxFit.cover,
                      imageUrl: message.msg,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          Icons.image,
                          size: 70,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem(
      {super.key, required this.icon, required this.name, required this.onTap});
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .012,
            bottom: mq.height * .02),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              '    $name',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
