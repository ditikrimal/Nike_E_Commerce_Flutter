// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/shoes_list.dart';
import 'package:nike_e_commerce/components/shop_body.dart';
import 'package:nike_e_commerce/models/shoe.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late Future<List<Shoe>> shoes;

  @override
  void initState() {
    super.initState();
    shoes = fetchShoesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: shoes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shop_page_body(shoeList([], isLoading: true));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return shop_page_body(emptyShoesList());
        } else {
          return shop_page_body(shoeList((snapshot.data as List<Shoe>)));
        }
      },
    );
  }
}
