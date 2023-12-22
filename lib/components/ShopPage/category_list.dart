import 'package:NikeStore/components/ShopPage/shoe_tile.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:flutter/material.dart';

SizedBox category_list(List<Shoe> shoes, {bool isLoading = false}) {
  return SizedBox(
    height: double.infinity,
    child: Container(
      height: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: shoes.length,
        itemBuilder: (context, index) {
          return ShoeTile(
            shoe: shoes[index],
          );
        },
      ),
    ),
  );
}
