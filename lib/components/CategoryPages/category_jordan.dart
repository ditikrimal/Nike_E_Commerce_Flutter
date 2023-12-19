import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/ShopPage/shoes_list.dart';
import 'package:nike_e_commerce/models/shoe.dart';

List<Shoe> testList = [
  Shoe(
    imagePath: 'lib/asset/images/Shoes (1).png',
    category: 'Jordan',
    shoeID: '1',
    name: 'Jordan 1 Retro High',
    price: 170,
    description:
        'The Air Jordan 1 High OG “Black/White” is the black and white edition of Michael Jordan’s first signature shoe. It is inspired by the original “Black Toe” Jordan 1 that released in 1985 with its most distinctive feature being the red “Nike Air” tongue tag. The construction features a premium leather upper with black overlays on the forefoot, eyelets, collar, and heel. Contrasting white leather appears on the perforated toe, mid-panel, and ankle collar. A black Wings logo dots the collar and a white leather Swoosh covers the mid-panel. A white midsole and black outsole with a red traction pattern complete the look of this classic Jordan 1. Release date: November 25, 2020.',
  ),
];
Widget categoryJordan() {
  return shoeList(testList);
}
