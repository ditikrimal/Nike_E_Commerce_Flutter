// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatefulWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: GNav(
          onTabChange: widget.onTabChange,
          color: Colors.grey[600],
          activeColor: Colors.black,
          tabBackgroundColor: Colors.grey.shade500,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 100,
          iconSize: 30,
          gap: 8,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Shop',
            ),
            GButton(
              icon: Icons.shopping_bag,
              text: 'Cart',
            ),
          ]),
    );
  }
}
