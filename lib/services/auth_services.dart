import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../view/login_screen/widgets/otp_screen.dart';

class AuthServices {
  final firebaseAuth = FirebaseAuth.instance;

  //login to the app using phone number
  void loginWithPhoneNumber(context, String phoneNumber) {
    try {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          log(e.toString());
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        phoneNumber: phoneNumber,
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log('\n signInWithPhoneNumber: $e');
    }
  }

  //otp Submit
  Future<void> otpSumbit(otpController, verificationId) async {
    final otp = otpController.text.trim();
    AuthCredential credential = PhoneAuthProvider.credential(
        smsCode: otp, verificationId: verificationId.toString());

    final User user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
    log(user.toString());
  }

  // login to the app using Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      log('\n signInWithGoogle: $e');
      return null;
    }
  }

  //signOut from the app
  Future<void> signOutUserAccount() async {
    try {
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      log('\n signOut: $e');
    }
  }
}
