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
        padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
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
            SizedBox(
              height: mq.height * .03,
            ),
            TextFormField(
              initialValue: userModel.name,
              decoration: InputDecoration(
                  hintText: 'Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14))),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            TextFormField(
              initialValue: userModel.about,
              decoration: InputDecoration(
                  hintText: 'About',
                  prefixIcon: const Icon(Icons.info_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14))),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          // provider.signOut();
        },
        elevation: 0,
        tooltip: 'Message',
        splashColor: Colors.lightBlue,
        icon: const Icon(
          Icons.logout_outlined,
          color: Colors.white,
          size: 29,
        ),
        label: const Text(
          'Log Out',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
