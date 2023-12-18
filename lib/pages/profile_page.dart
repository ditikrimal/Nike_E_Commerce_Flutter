// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nike_e_commerce/authHandle/email_handle.dart';
import 'package:nike_e_commerce/pages/UserAuth/login_page.dart';
import 'package:nike_e_commerce/pages/UserAuth/profile_pageView.dart';
import 'package:nike_e_commerce/pages/UserAuth/verifyemail_page.dart';
import 'package:nike_e_commerce/pages/welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _isCheckingEmail;

  @override
  void initState() {
    super.initState();
    _isCheckingEmail = true;

    // Check email verification status
    _checkEmailVerificationStatus();
  }

  Future<void> _checkEmailVerificationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final isEmailVerified = await checkEmail(user.email);
      setState(() {
        _isCheckingEmail = false;
      });
      if (isEmailVerified) {
        // Handle the case when email is verified
      } else {
        user.sendEmailVerification();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VeryEmailPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProfilePageView(
            isLoading: true,
          ); // Loading state
        }
        if (snapshot.hasData) {
          if (_isCheckingEmail) {
            return ProfilePageView(
              isLoading: true,
            ); // Loading state
          } else {
            return ProfilePageView(
              isLoading: false,
            );
          }
        } else {
          return LoginPage();
        }
      },
    );
  }
}
