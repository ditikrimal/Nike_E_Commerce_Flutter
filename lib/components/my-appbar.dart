import 'package:NikeStore/components/back_button.dart';
import 'package:NikeStore/pages/home_page.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? myAppBar(BuildContext context, String? title,
    {bool cartOption = false}) {
  return AppBar(
    toolbarHeight: 75,
    backgroundColor: Colors.grey[300],
    leading: backArrow(context),
    title: Text(
      title ?? '',
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      cartOption
          ? IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      initialPageIndex: 1,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
              iconSize: 30,
            )
          : Container(),
    ],
  );
}
