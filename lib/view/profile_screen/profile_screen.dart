import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Screen',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: userModel.image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
