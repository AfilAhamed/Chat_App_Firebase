import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;

  // to check weather a user exists or not
  Future<bool> userExists() async {
    return (await firestore.collection('users').doc(auth!.uid).get()).exists;
  }

  createUser() {
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
}
