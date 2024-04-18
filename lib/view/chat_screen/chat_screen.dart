import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/view/chat_screen/widget/message_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> list = [];

  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  width: mq.height * .060,
                  height: mq.height * .060,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: mq.width * 0.04,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'last scene',
                    style: TextStyle(
                        color: Colors.grey.shade100,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreServices().getAllMessages(widget.user),
                builder: (context, snapshoot) {
                  final data = snapshoot.data!.docs;
                  // log('data ${jsonEncode(data[0].data())}');
                  list =
                      data.map((e) => MessageModel.fromJson(e.data())).toList();

                  if (snapshoot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (list.isNotEmpty) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8.0),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return MessageCard(message: list[index]);
                        });
                  } else {
                    return const Center(
                      child: Text('No Chats yet'),
                    );
                  }
                },
              ),
            ),
            //-------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * .025, vertical: mq.height * .01),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.blueAccent,
                                size: 25,
                              )),
                          Expanded(
                              child: TextFormField(
                            controller: messageController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                hintText: 'Type Somthing...',
                                hintStyle: TextStyle(color: Colors.blueAccent),
                                border: InputBorder.none),
                          )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.image,
                                color: Colors.blueAccent,
                                size: 26,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.blueAccent,
                                size: 26,
                              )),
                          SizedBox(
                            width: mq.width * .02,
                          )
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        FireStoreServices()
                            .sendMessages(widget.user, messageController.text);
                        messageController.text = '';
                      }
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 5),
                    color: Colors.green,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}