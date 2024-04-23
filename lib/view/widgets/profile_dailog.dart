import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/view/chat_screen/widget/view_user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDailog extends StatelessWidget {
  const ProfileDailog({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            Positioned(
              top: mq.height * .075,
              left: mq.width * .075,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.width * .50,
                  height: mq.height * .24,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            Positioned(
              left: mq.width * .04,
              top: mq.height * .02,
              width: mq.width * .55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
                right: 8,
                top: 6,
                child: MaterialButton(
                  shape: const CircleBorder(),
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewUserProfile(userModel: user),
                        ));
                  },
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 25,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
