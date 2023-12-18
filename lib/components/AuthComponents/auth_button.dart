// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/authHandle/register_handle.dart';

class AuthButton extends StatelessWidget {
  Function() onTap;
  String buttonLabel;
  AuthButton({
    super.key,
    required this.onTap,
    this.buttonLabel = 'Login',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          buttonLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
