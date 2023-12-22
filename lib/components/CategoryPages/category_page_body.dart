import 'package:NikeStore/models/shoe.dart';
import 'package:flutter/material.dart';

Widget category_list(
    List<Shoe> shoes, String categoryName, BuildContext context,
    {bool isLoading = false}) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Category $categoryName}'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
