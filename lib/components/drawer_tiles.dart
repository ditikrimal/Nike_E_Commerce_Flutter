// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  final Icon icon;
  void Function()? onTap;

  final String listName;
  DrawerTile({
    super.key,
    required this.icon,
    required this.listName,
    this.onTap,
  });

  @override
  State<DrawerTile> createState() => DrawerTileState();
}

class DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 30),
      leading: widget.icon,
      iconColor: Colors.white,
      onTap: widget.onTap,
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
