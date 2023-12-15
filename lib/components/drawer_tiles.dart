// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  final Icon icon;
  final String listName;
  const DrawerTile({
    super.key,
    required this.icon,
    required this.listName,
  });

  @override
  State<DrawerTile> createState() => DrawerTileState();
}

class DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 25),
      leading: widget.icon,
      iconColor: Colors.white,
      title: Text(
        widget.listName.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
