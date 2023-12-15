// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/pages/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        dividerTheme: DividerThemeData(color: Colors.transparent),
      ),
    );
  }
}

class FirebaseFirestore {}
