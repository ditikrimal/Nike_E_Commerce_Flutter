// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nike_e_commerce/firebase_options.dart';
import 'package:nike_e_commerce/pages/UserAuth/login_page.dart';
import 'package:nike_e_commerce/pages/UserAuth/signup_page.dart';
import 'package:nike_e_commerce/pages/UserAuth/verifyotp_page.dart';
import 'package:nike_e_commerce/pages/home_page.dart';
import 'package:nike_e_commerce/pages/profile_page.dart';
import 'package:nike_e_commerce/pages/welcome_page.dart';
import 'package:nike_e_commerce/provider/cart_provider.dart';
import 'package:nike_e_commerce/provider/shoes_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShoeProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/profile': (context) => ProfilePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/verifyotp': (context) => OTPVerify(
              otp: null,
              email: '',
              name: '',
            ),
      },
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFE0E0E0, const <int, Color>{
          50: Color(0xFFE0E0E0),
          100: Color(0xFFBDBDBD),
          200: Color(0xFF9E9E9E),
          300: Color(0xFF757575),
          400: Color(0xFF616161),
          500: Color(0xFF424242),
          600: Color(0xFF303030),
          700: Color(0xFF212121),
          800: Color(0xFF171717),
          900: Color(0xFF000000),
        }),
        dividerTheme: DividerThemeData(color: Colors.transparent),
      ),
    );
  }
}
