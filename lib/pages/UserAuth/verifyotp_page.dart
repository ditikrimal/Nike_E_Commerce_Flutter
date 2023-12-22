// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:NikeStore/authHandle/OTP_handle.dart';
import 'package:NikeStore/components/AuthComponents/auth_button.dart';
import 'package:NikeStore/components/alert_snackbar.dart';
import 'package:NikeStore/components/loading_progress.dart';
import 'package:NikeStore/pages/home_page.dart';
import 'package:NikeStore/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OTPVerify extends StatefulWidget {
  var otp;
  final String email;
  final String name;
  OTPVerify({
    super.key,
    required this.otp,
    required this.email,
    required this.name,
  });

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  @override
  void initState() {
    super.initState();
    _otpController.text = '';
  }

  final TextEditingController _otpController = TextEditingController();
  final defaultPinTheme = PinTheme(
    decoration: BoxDecoration(
      color: Color.fromARGB(201, 191, 191, 191),
      //underline border
      borderRadius: BorderRadius.circular(10),
    ),
    width: 60,
    height: 60,
    textStyle: TextStyle(fontSize: 24, color: Colors.black),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: Icon(Icons.close),
          color: Colors.black,
          iconSize: 35,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Verification code',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'We have sent the verification code to ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Pinput(
                    enableSuggestions: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    defaultPinTheme: defaultPinTheme,
                    controller: _otpController,
                    length: 6,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: AuthButton(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return loadingProgress(0.5);
                      });
                  if (_otpController.text == widget.otp) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomAlertBar.success(
                        messageStatus: 'Success',
                        message: 'OTP validated',
                        secondaryMessage: ' (Redirecting shortly)',
                      ),
                    );

                    // Store verification status locally
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isVerified', true);

                    FirebaseFirestore.instance
                        .collection('UserInfo')
                        .doc(widget.email)
                        .set({
                      'name': widget.name,
                      'email': widget.email,
                      'photoUrl': "",
                      'phoneNumber': "",
                      'isVerified': true,
                    });
                    Navigator.pop(context);
                    Future.delayed(Duration(seconds: 3), () {
                      CircularProgressIndicator();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    });
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomAlertBar.error(
                        messageStatus: 'Error',
                        message: 'Invalid OTP',
                        secondaryMessage: ' (Try Again)',
                      ),
                    );
                  }
                },
                buttonLabel: 'Verify',
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive the code?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
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
              radius: 10,
              textColor: Colors.white,
              buttonType: ButtonType.elevated_button,
              loadingIndicator: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
              loadingIndicatorColor: Colors.red,
              onPressed: () {
                sendOTPEmail(
                    user_fullName: widget.name, user_email: widget.email);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }
}
