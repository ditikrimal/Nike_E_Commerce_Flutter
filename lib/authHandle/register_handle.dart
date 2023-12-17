// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nike_e_commerce/authHandle/OTP_handle.dart';
import 'package:nike_e_commerce/components/alert_snackbar.dart';
import 'package:nike_e_commerce/pages/UserAuth/verifyotp_page.dart';
import 'package:nike_e_commerce/services/auth/auth_exceptions.dart';
import 'package:nike_e_commerce/services/auth/auth_service.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterHandle {
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      await AuthService.firebase()
          .createUser(name: name, email: email, password: password);

      String otp = await sendOTPEmail(user_fullName: name, user_email: email);
      FirebaseFirestore.instance.collection('UserInfo').doc(email).set({
        'name': name,
        'email': email,
        'photoUrl': "",
        'phoneNumber': "",
        'isVerified': false,
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerify(
                    name: name,
                    email: email,
                    otp: otp,
                  )));
    } on EmptyFieldAuthException {
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.error(
          messageStatus: 'Error',
          message: 'Empty Fields',
        ),
      );
      Navigator.pop(context);
    } on InvalidEmailAuthException {
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.error(
          messageStatus: 'Error',
          message: 'Invalid Email',
        ),
      );
      Navigator.pop(context);
    } on WeakPasswordAuthException {
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.error(
          messageStatus: 'Error',
          message: 'Weak Password',
          secondaryMessage: ' (Minimum 6 characters)',
        ),
      );
      Navigator.pop(context);
    } on EmailAlreadyTakenAuthException {
      showTopSnackBar(
        Overlay.of(context),
        CustomAlertBar.error(
          messageStatus: 'Error',
          message: 'Email already taken',
        ),
      );
      Navigator.pop(context);
    }
  }
}
