import 'package:flutter/material.dart';

Widget ProfileListTile(String listLabel, IconData listIcon, Function() onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Color.fromARGB(232, 238, 238, 238),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        leading: Icon(
          listIcon,
          size: 25,
        ),
        title: Text(listLabel,
            style: const TextStyle(
              fontSize: 18,
            )),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
        ),
      ),
    ),
  );
}
