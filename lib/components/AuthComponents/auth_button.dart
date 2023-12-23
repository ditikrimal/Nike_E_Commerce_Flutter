// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  Function() onTap;
  String buttonLabel;
  double buttonWidth;
  double vericalPadding;
  double radius;
  double fontSize;
  AuthButton({
    super.key,
    required this.onTap,
    this.buttonLabel = 'Login',
    this.buttonWidth = double.infinity,
    this.vericalPadding = 18,
    this.radius = 10,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: vericalPadding),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(radius),
        ),
        width: buttonWidth,
        alignment: Alignment.center,
        child: Text(
          buttonLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
