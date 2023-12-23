import 'package:flutter/material.dart';

IconButton backArrow(context) {
  return IconButton(
    padding: EdgeInsets.fromLTRB(15, 7, 7, 7),
    onPressed: () => Navigator.pop(context),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shape: MaterialStateProperty.all(CircleBorder()),
    ),
    icon: const Icon(
      Icons.arrow_back_ios,
      color: Colors.black,
    ),
    iconSize: 20,
  );
}
