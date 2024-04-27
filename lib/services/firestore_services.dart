import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class FireStoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  final auth = FirebaseAuth.instance.currentUser;

  static late UserModel me;

  // to check weather a user exists or not
  Future<bool> userExists() async {
    return (await firestore.collection('users').doc(auth!.uid).get()).exists;
  }

  // add chat user
  Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    log('data ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != auth!.uid) {
      log('user exists ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(auth!.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true; //user exist
    } else {
      return false; //user dose not exist
    }
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

  // get user profile information
  Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(auth!.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getFirebseMessagingToken();
        updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //get my users id
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(auth!.uid)
        .collection('my_users')
        .snapshots();
  }

  //get all users
  Stream<QuerySnapshot<Map<String, dynamic>>>? getAllUsers(
      List<String> userIds) {
    log(userIds.toString());
    if (userIds.isNotEmpty) {
      return firestore
          .collection('users')
          .where('id', whereIn: userIds)
          .snapshots();
    }
    return null;
  }
 //send first message with creating my_users collection
  Future<void> sendFirstMessage(UserModel user, String msg, Type type) async {
    return await firestore
        .collection('users')
        .doc(user.id)
        .collection('my_users')
        .doc(auth!.uid)
        .set({}).then((value) => sendMessages(user, msg, type));
  }

  // update user profile info
  Future<void> updateUserInfo() async {
    return await firestore
        .collection('users')
        .doc(auth!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //  update user profile picture
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

 //for getting user information
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(UserModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // updare  online status 
  Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(auth!.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }


  //-------------------Chat Functionality------------------------//

  //conversation id (chat room)
  String getConversationId(String id) => auth!.uid.hashCode <= id.hashCode
      ? '${auth!.uid}_$id'
      : '${id}_${auth!.uid}';

  //get all Messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages')
        .orderBy('sendTime', descending: true)
        .snapshots();
  }

  // send messages
  Future<void> sendMessages(UserModel user, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final MessageModel message = MessageModel(
        toId: user.id,
        msg: msg,
        readTime: '',
        type: type,
        fromId: auth!.uid,
        sendTime: time);

    final ref =
        firestore.collection('chats/${getConversationId(user.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(user, type == Type.text ? msg : 'image'));
  }

  // read message status
  Future<void> updateReadMessageStatus(MessageModel message) async {
    await firestore
        .collection('chats/${getConversationId(message.fromId)}/messages')
        .doc(message.sendTime)
        .update({'readTime': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(UserModel user) {
    return firestore
        .collection('chats/${getConversationId(user.id)}/messages')
        .orderBy('sendTime', descending: true)
        .limit(1)
        .snapshots();
  }

  // send images in chat
  Future<void> sendChatImage(UserModel chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => log('Data Transfered: ${p0.bytesTransferred / 1000} kb'));
    final imageUrl = await ref.getDownloadURL();
    await sendMessages(chatUser, imageUrl, Type.image);
  }

  // delete chat messages
  Future<void> deleteMessage(MessageModel message) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages')
        .doc(message.sendTime)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  // update chat messages
  Future<void> updateMessage(
      MessageModel message, String updatedMessage) async {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages')
        .doc(message.sendTime)
        .update({'msg': updatedMessage});
  }




  //-------------------Fcm Notification Functionality------------------------//

  // get Firebase Token
  Future<void> getFirebseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((value) {
      if (value != null) {
        me.pushToken = value;
        log(value);
      }
    });

    // for foreground notififcations--

    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // push notification message
  Future<void> sendPushNotification(UserModel user, String message) async {
    final data = {
      "to": user.pushToken,
      "notification": {
        "title": user.name,
        "body": message,
        // "android_channel_id": "chats",
      },
      // "data": {
      //   "some_data": "User D ${me.id}",
      // }
    };
    const url = 'https://fcm.googleapis.com/fcm/send';
    try {
      final response =
          await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
        HttpHeaders.authorizationHeader:
            "key=cxzgT9cYTdeCCMoSTvRfRg:APA91bGiKZ0yQ6p33aJccWTuPVzDiSMyYK_yGWYjvZg3eyQM1uMdZ5wWQ8T6QTYGx8CVXAtoxWxD8p9H6yhhzhsrcmASNzQDgCcQwhvC8kh3UzuXAkY1V8PxibTcW5wht2h4Dors9X0h"
      });
      if (response.statusCode == 201) {
        log('Notification Sended Succesfully');
      } else {
        log('Failed to send Notification');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
