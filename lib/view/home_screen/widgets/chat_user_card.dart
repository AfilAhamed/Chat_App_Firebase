import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/date_util.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/view/chat_screen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ChatUserCardWidget extends StatelessWidget {
  ChatUserCardWidget({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    MessageModel? message;

    final mq = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: ChatScreen(user: userModel),
                    type: PageTransitionType.fade));
          },
          child: StreamBuilder(
            stream: FireStoreServices().getLastMessage(userModel),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => MessageModel.fromJson(e.data())).toList() ??
                      [];
              if (list.isNotEmpty) {
                message = list[0];
              }

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: userModel.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                title: Text(userModel.name),
                subtitle: Text(
                  message != null
                      ? message!.type == Type.image
                          ? 'image'
                          : message!.msg
                      : userModel.about,
                  maxLines: 1,
                ),
                trailing: message == null
                    ? null
                    : message!.readTime.isEmpty &&
                            message!.fromId != FireStoreServices().auth!.uid
                        ? Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.shade400,
                            ),
                          )
                        : Text(
                            DateUtil().getLastMessageTime(
                                context: context, time: message!.sendTime),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
