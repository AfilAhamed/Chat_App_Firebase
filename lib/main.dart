import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/view/auth_screen/auth_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white, size: 28))),
      home: const AuthGateWay(),
    );
  }
}
