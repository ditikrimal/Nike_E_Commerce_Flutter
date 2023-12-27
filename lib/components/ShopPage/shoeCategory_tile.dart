import 'package:flutter/material.dart';

Widget categoryTile(String imagePath, String label, Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(500),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 70,
          ),
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}
