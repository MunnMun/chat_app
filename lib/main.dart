import 'package:chat_app/pages/chatRoom.dart';
import 'package:chat_app/pages/conversation.dart';
import 'package:chat_app/pages/forgotPassword.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/pages/signIn.dart';
import 'package:chat_app/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null) ? ChatRoom() : SignIn()
    );
  }
}