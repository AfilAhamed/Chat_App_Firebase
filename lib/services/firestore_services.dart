import 'dart:developer';
import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final auth = FirebaseAuth.instance.currentUser;
  static late UserModel me;

  // to check weather a user exists or not
  Future<bool> userExists() async {
    return (await firestore.collection('users').doc(auth!.uid).get()).exists;
  }

  //create user
  Future<void> createUser() {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final userModel = UserModel(
        name: auth!.displayName.toString(),
        about: 'hi there! i am using chatapp',
        image: auth!.photoURL.toString(),
        createdAt: time,
        id: auth!.uid,
        lastActive: time,
        email: auth!.email.toString(),
        pushToken: '',
        isOnline: false);

    return firestore.collection('users').doc(auth!.uid).set(userModel.toJson());
  }

  Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(auth!.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: auth!.uid)
        .snapshots();
  }

  Future<void> updateUserInfo() async {
    return await firestore
        .collection('users')
        .doc(auth!.uid)
        .update({'name': me.name, 'about': me.about});
  }


 // to update the profile picture
  Future<void> updateProfilPicture(File file) async {
    final ext = file.path.split('.').last;
    log('profile picture extension$ext');
    final ref = storage.ref().child('Profile_Pictures/${auth!.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => log('Data Transfered: ${p0.bytesTransferred / 1000} kb'));
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(auth!.uid)
        .update({"image": me.image});
  }
}
