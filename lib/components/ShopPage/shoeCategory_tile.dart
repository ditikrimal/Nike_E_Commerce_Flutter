import 'dart:math';

import 'package:flutter/material.dart';

Widget categoryTile(String imagePath, String label, Function()? onTap,
    {bool isLargeScreen = false}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      constraints: BoxConstraints(maxWidth: 150, maxHeight: 100),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(500),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: isLargeScreen ? 200 : 60,
            width: isLargeScreen ? 500 : 60, // Set a fixed size for the image
          ),
          SizedBox(height: 8), // Add some space between image and text
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              // You can adjust the text style based on screen size
            ),
            textAlign: TextAlign.center, // Center the text
          ),
        ],
      ),
    ),
  );
}
