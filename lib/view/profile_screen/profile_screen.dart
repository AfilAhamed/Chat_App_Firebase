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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
        child: Column(
          children: [
            SizedBox(
              height: mq.height * .03,
              width: mq.width,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .1),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                width: mq.height * .2,
                height: mq.height * .2,
                imageUrl: userModel.image,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userModel.email,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
            TextFormField(
              initialValue: userModel.name,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            )
          ],
        ),
      ),
    );
  }
}
