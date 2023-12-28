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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: mq.height * .2,
                      height: mq.height * .2,
                      imageUrl: userModel.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                        elevation: 1,
                        color: Colors.white,
                        shape: const CircleBorder(),
                        onPressed: () {},
                        child: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        )),
                  )
                ],
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
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(14)),
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
                    prefixIcon: const Icon(
                      Icons.info_outlined,
                      color: Colors.blue,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(14)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14))),
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(mq.width * .4, mq.height * .06),
                      backgroundColor: Colors.blue),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Update',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: const StadiumBorder(),
        backgroundColor: Colors.blue,
        onPressed: () {
          // provider.signOut();
        },
        elevation: 0,
        tooltip: 'Log Out',
        splashColor: Colors.lightBlue,
        icon: const Icon(
          Icons.logout_outlined,
          color: Colors.white,
          size: 29,
        ),
        label: const Text(
          'Log Out',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }
}