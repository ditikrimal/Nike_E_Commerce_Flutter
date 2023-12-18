// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nike_e_commerce/components/alert_snackbar.dart';
import 'package:nike_e_commerce/pages/UserAuth/login_page.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Future<String> sendOTPEmail({
  required String? user_fullName,
  required String? user_email,
}) async {
  final otp = Random().nextInt(999999).toString().padLeft(6, '0');

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36', // Use a common web browser user agent
      },
      body: json.encode({
        'service_id': 'service_2uzb135',
        'template_id': 'template_hqh955u',
        'user_id': 'WZpXrLCwheXTLuzc8',
        'template_params': {
          'user_fullName': user_fullName,
          'user_email': user_email,
          'otp': otp,
        },
      }));
  if (response.body == 'OK') {
    FirebaseFirestore.instance.collection('UserInfo').doc(user_email).set({
      'name': user_fullName,
      'email': user_email,
      'photoUrl': "",
      'phoneNumber': "",
      'isVerified': false,
    });

    return otp;
  } else {
    throw Exception('Failed to send OTP');
  }
}
