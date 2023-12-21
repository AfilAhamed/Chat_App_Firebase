import 'package:chat_app/view/login_screen/login_screen.dart';
import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGateWay extends StatelessWidget {
  const AuthGateWay({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            return const HomeScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          return const UserLoginScreen();
        });
  }
}
