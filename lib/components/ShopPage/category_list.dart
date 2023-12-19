import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/ShopPage/shoe_tile.dart';
import 'package:nike_e_commerce/models/shoe.dart';

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
