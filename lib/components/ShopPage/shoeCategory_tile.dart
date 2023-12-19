import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

SizedBox categoryTile(String imagePath, String label, Function()? onTap) {
  return SizedBox(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(500),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 100,
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
