import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/dailogs.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controller/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);

    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
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
                      imagePath != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(imagePath!),
                                fit: BoxFit.cover,
                                width: mq.height * .2,
                                height: mq.height * .2,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: mq.height * .2,
                                height: mq.height * .2,
                                imageUrl: widget.userModel.image,
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
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
                            onPressed: () {
                              //------------
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (builder) {
                                    return ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                          top: mq.height * .03,
                                          bottom: mq.height * .05),
                                      children: [
                                        const Text(
                                          'Pick a Profile Picture',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: mq.height * .02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: const CircleBorder(),
                                                    fixedSize: Size(
                                                        mq.width * .3,
                                                        mq.height * .15)),
                                                onPressed: () async {
                                                  final ImagePicker picker =
                                                      ImagePicker();
                                                  final XFile? image =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,);
                                                  if (image != null) {
                                                    log(image.path);
                                                    setState(() {
                                                      imagePath = image.path;
                                                    });
                                                     FireStoreServices()
                                                      .updateProfilPicture(File(imagePath!));
                                                    Navigator.pop(context);
                                                  }
                                                 
                                                },
                                                child: Image.asset(
                                                    'assets/add_image.png')),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: const CircleBorder(),
                                                    fixedSize: Size(
                                                        mq.width * .3,
                                                        mq.height * .15)),
                                                onPressed: () async {
                                                  final ImagePicker picker =
                                                      ImagePicker();
                                                  final XFile? image =
                                                      await picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  if (image != null) {
                                                    log(image.path);
                                                    setState(() {
                                                      imagePath = image.path;
                                                    });
                                                    Navigator.pop(context);
                                                  }
                                                    FireStoreServices()
                                                      .updateProfilPicture(File(imagePath!));
                                                },
                                                child: Image.asset(
                                                    'assets/camera.png')),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            },
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
                    widget.userModel.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  TextFormField(
                    onSaved: (val) => FireStoreServices.me.name = val ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      } else {
                        return null;
                      }
                    },
                    initialValue: widget.userModel.name,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.blue),
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
                    onSaved: (val) => FireStoreServices.me.about = val ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your About';
                      } else {
                        return null;
                      }
                    },
                    initialValue: widget.userModel.about,
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          FireStoreServices().updateUserInfo().then((value) =>
                              Dailogas()
                                  .showSnackBar(context, 'Profile Updated'));
                        }
                      },
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: const StadiumBorder(),
          backgroundColor: Colors.blue,
          onPressed: () {
            provider.signOut();
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
      ),
    );
  }
}
