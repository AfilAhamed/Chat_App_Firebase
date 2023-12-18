import 'package:chat_app/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: const HomeScreen(),
    );
  }
}
