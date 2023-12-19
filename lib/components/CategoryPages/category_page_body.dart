import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/ShopPage/shoe_tile.dart';
import 'package:nike_e_commerce/models/shoe.dart';

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
