// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/shoe_tile.dart';
import 'package:nike_e_commerce/models/shoe.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //create a search bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 17),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(
                5,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search'.toUpperCase(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
              ),
              Icon(
                Icons.search,
                size: 25,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),

        //show a message
        Container(
          padding: const EdgeInsets.all(15.0),
          alignment: Alignment.center,
          child: Text(
            'where comfort meets fashion, NIKE',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        //hot picks from shoes

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Hot Picks 🔥',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    decoration: TextDecoration.underline),
              )
            ],
          ),
        ),
        SizedBox(
          height: 450,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              Shoe shoe = Shoe(
                name: 'Air Jordan',
                price: '240',
                imagePath: 'lib/images/Shoes.png',
                description: 'This is cool shoe. Very Good',
              );

              return ShoeTile(
                shoe: shoe,
              );
            },
          ),
        ),
      ],
    );
  }
}
