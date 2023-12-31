// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:NikeStore/authHandle/email_handle.dart';
import 'package:NikeStore/components/AuthComponents/auth_button.dart';
import 'package:NikeStore/components/alert_snackbar.dart';
import 'package:NikeStore/components/loading_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VeryEmailPage extends StatelessWidget {
  VeryEmailPage({super.key});

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
            color: Colors.black,
            iconSize: 35,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.email_outlined,
                size: 100,
                color: Colors.black,
              ),
              SizedBox(height: 20),
              Text(
                'Your email is not verified yet.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'A verification link has been sent to ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "\"${user?.email}\"" ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Click the continue button below once you have verified your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
              SizedBox(height: 20),
              AuthButton(
                onTap: () {
                  user?.reload();
                  print(user);
                  if (user?.emailVerified == true) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomAlertBar.success(
                        messageStatus: 'Succes',
                        message: 'Email verified successfully.',
                      ),
                    );
                    updateEmailVerification(user?.email!);

                    Navigator.pop(context);
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomAlertBar.error(
                        messageStatus: 'Error',
                        message: 'Email not verified yet.',
                      ),
                    );
                  }
                },
                buttonLabel: 'Continue',
              ),
              SizedBox(height: 10),
              AuthButton(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  buttonLabel: 'Logout'),
              SizedBox(height: 20),
              Text(
                'Didn\'t receive the email?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              OtpTimerButton(
                height: 48,
                text: Text(
                  'Resend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                duration: 60,
                radius: 6,
                textColor: Colors.white,
                buttonType: ButtonType.elevated_button,
                loadingIndicator: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
                loadingIndicatorColor: Colors.black,
                onPressed: () {
                  user?.sendEmailVerification();
                },
              ),
            ],
          ),
        ));
  }
}
