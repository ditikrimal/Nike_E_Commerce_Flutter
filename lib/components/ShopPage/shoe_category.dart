import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nike_e_commerce/components/ShopPage/category_list.dart';
import 'package:nike_e_commerce/components/ShopPage/shoeCategory_tile.dart';
import 'package:nike_e_commerce/components/ShopPage/shop_body.dart';

GridView shoesCategory() {
  return GridView.count(
    crossAxisSpacing: 20,
    mainAxisSpacing: 20,
    childAspectRatio: 1,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 50),
    crossAxisCount: 2,
    shrinkWrap: true,
    children: [
      categoryTile(
        'lib/asset/images/shoes_category/Jordan.png',
        'Jordan',
        () {},
      ),
      categoryTile(
        'lib/asset/images/shoes_category/Basketball.png',
        'Basketball',
        () {},
      ),
      categoryTile(
        'lib/asset/images/shoes_category/Soccer.png',
        'Soccer',
        () {},
      ),
      categoryTile(
        'lib/asset/images/shoes_category/Running.png',
        'Running',
        () {},
      ),
      categoryTile(
        'lib/asset/images/shoes_category/Skate.png',
        'Skate',
        () {},
      ),
      categoryTile(
        'lib/asset/images/shoes_category/TrainingAndGym.png',
        'Gym',
        () {},
      ),
    ],
  );
}
