import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/helpers/dailogs.dart';
import 'package:chat_app/helpers/date_util.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/view/auth_screen/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ViewUserProfile extends StatefulWidget {
  const ViewUserProfile({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<ViewUserProfile> createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);

    final mq = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text(
              widget.userModel.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: mq.height * .03,
                    width: mq.width,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: mq.height * .2,
                      height: mq.height * .2,
                      imageUrl: widget.userModel.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.userModel.email,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        widget.userModel.about,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              Text(
                DateUtil().getLastMessageTime(
                    context: context,
                    time: widget.userModel.createdAt,
                    showYear: true),
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
