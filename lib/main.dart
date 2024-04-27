import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/search_controller.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/view/auth_screen/auth_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => SearchUserController())
      ],
      child: MaterialApp(
        title: 'ChatApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
                toolbarHeight: 65,
                centerTitle: true,
                backgroundColor: Colors.blue,
                iconTheme: IconThemeData(color: Colors.white, size: 28))),
        home: const AuthGateWay(),
      ),
    );
  }
}
