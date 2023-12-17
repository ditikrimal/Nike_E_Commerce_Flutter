// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nike_e_commerce/authHandle/email_handle.dart';
import 'package:nike_e_commerce/pages/UserAuth/login_page.dart';
import 'package:nike_e_commerce/pages/UserAuth/profile_pageView.dart';
import 'package:nike_e_commerce/pages/welcome_page.dart';
import 'package:nike_e_commerce/services/auth/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        try {
          final user = FirebaseAuth.instance.currentUser!.emailVerified;
          final userEmail = FirebaseAuth.instance.currentUser?.email;

          if (user != null) {
            return FutureBuilder<bool>(
              future: checkEmail(userEmail),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true || user == true) {
                  updateEmailVerification(userEmail);
                  return ProfilePageView();
                } else {
                  return ProfilePageView();
                }
              },
            );
          } else {
            return LoginPage();
          }
        } catch (e) {
          return LoginPage();
        }
      },
    );
  }
}
