import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/date_util.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/view/chat_screen/widget/message_card.dart';
import 'package:chat_app/view/chat_screen/widget/view_user_profile.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> list = [];
  bool showEmoji = false, isUploading = false;

  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (showEmoji) {
              setState(() {
                showEmoji = !showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 234, 248, 255),
            appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                title: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewUserProfile(userModel: widget.user),
                        ));
                  },
                  child: StreamBuilder(
                    stream: FireStoreServices().getUserInfo(widget.user),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.docs;
                      final list = data
                              ?.map((e) => UserModel.fromJson(e.data()))
                              .toList() ??
                          [];
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .3),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              width: mq.height * .060,
                              height: mq.height * .060,
                              imageUrl: list.isNotEmpty
                                  ? list[0].image
                                  : widget.user.image,
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
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
                                list.isNotEmpty
                                    ? list[0].name
                                    : widget.user.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                list.isNotEmpty
                                    ? !list[0].isOnline
                                        ? 'Online'
                                        : DateUtil().getLastActiveTime(
                                            context: context,
                                            lastActive: list[0].lastActive)
                                    : DateUtil().getLastActiveTime(
                                        context: context,
                                        lastActive: widget.user.lastActive),
                                style: TextStyle(
                                    color: Colors.grey.shade100,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                )),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FireStoreServices().getAllMessages(widget.user),
                    builder: (context, snapshoot) {
                      final data = snapshoot.data!.docs;
                      // log('data ${jsonEncode(data[0].data())}');
                      list = data
                          .map((e) => MessageModel.fromJson(e.data()))
                          .toList();

                      if (snapshoot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (list.isNotEmpty) {
                        return ListView.builder(
                            reverse: true,
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
                // progress indicator for uploading images
                if (isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
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
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      showEmoji = !showEmoji;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  )),
                              Expanded(
                                  child: TextFormField(
                                onTap: () {
                                  if (showEmoji) {
                                    setState(() {
                                      showEmoji = !showEmoji;
                                    });
                                  }
                                },
                                controller: messageController,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    hintText: 'Type Somthing...',
                                    hintStyle:
                                        TextStyle(color: Colors.blueAccent),
                                    border: InputBorder.none),
                              )),
                              IconButton(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final List<XFile> images =
                                        await picker.pickMultiImage(
                                      imageQuality: 70,
                                    );
                                    for (var i in images) {
                                      log(i.path);
                                      setState(() => isUploading = true);

                                      await FireStoreServices().sendChatImage(
                                          widget.user, File(i.path));
                                      setState(() => isUploading = false);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.image,
                                    color: Colors.blueAccent,
                                    size: 26,
                                  )),
                              IconButton(
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 70,
                                    );
                                    if (image != null) {
                                      log(image.path);
                                      setState(() => isUploading = true);
                                      await FireStoreServices().sendChatImage(
                                          widget.user, File(image.path));
                                      setState(() => isUploading = false);
                                    }
                                  },
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
                            FireStoreServices().sendMessages(
                                widget.user, messageController.text, Type.text);
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
                ),
                //emoji picker
                if (showEmoji)
                  EmojiPicker(
                    textEditingController: messageController,
                    config: Config(
                      categoryViewConfig: const CategoryViewConfig(
                          backgroundColor: Color.fromARGB(255, 234, 248, 255)),
                      height: mq.height * .38,
                      // checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        backgroundColor:
                            const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
