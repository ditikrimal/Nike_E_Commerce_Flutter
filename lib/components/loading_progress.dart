import 'package:flutter/material.dart';

SizedBox loadingProgress() {
  return SizedBox(
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress indicator
          const CircularProgressIndicator(
            color: Colors.black, // Adjust the color as needed
          ),

          // Your logo image overlaying the circular progress indicator
          Image.asset(
            'lib/asset/images/NikeLogo.png', // Replace with the path to your logo image
            width: 30, // Adjust the width as needed
            height: 30, // Adjust the height as needed
          ),
        ],
      ),
    ),
  );
}
