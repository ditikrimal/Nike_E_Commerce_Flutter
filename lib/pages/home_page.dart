// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:NikeStore/authHandle/googleAuth_handle.dart';
import 'package:NikeStore/components/bottom_nav_bar.dart';
import 'package:NikeStore/components/drawer_tiles.dart';
import 'package:NikeStore/pages/cart_page.dart';
import 'package:NikeStore/pages/profile_page.dart';
import 'package:NikeStore/pages/shop_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int initialPageIndex;
  const HomePage({
    super.key,
    this.initialPageIndex = 0,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

final GoogleAuthHandle _authService = GoogleAuthHandle();

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> products = [
    {
      "name": "LeBron XXI \"Abalone\"",
      "price": 150.97,
      "imagePath": "lib/asset/images/Shoes (12).png",
      "description":
          "Showcase your style with the LeBron XXI \"Abalone,\" a basketball shoe with 5 eye-catching colors.",
      "category": "Basketball",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Air Jordan XXXVIII \"Aqua\"",
      "price": 200.0,
      "imagePath": "lib/asset/images/Shoes (9).png",
      "description":
          "Dive into the game with the Air Jordan XXXVIII \"Aqua,\" designed for performance and style in 4 colors.",
      "category": "Basketball",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Nike Air Trainer 1 \"College Football Playoff\"",
      "price": 140.0,
      "imagePath": "lib/asset/images/Shoes (14).png",
      "description":
          "Celebrate your love for football with the Nike Air Trainer 1 \"College Football Playoff\" in 2 vibrant colors.",
      "category": "Football",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Sabrina 1 \"West Coast Roots\"",
      "price": 130.0,
      "imagePath": "lib/asset/images/Shoes (8).png",
      "description":
          "Dominate the court with Sabrina 1 \"West Coast Roots,\" a basketball shoe available in 5 dynamic colors.",
      "category": "Basketball",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Nike Metcon 9 AMP",
      "price": 160.0,
      "imagePath": "lib/asset/images/Shoes (17).png",
      "description":
          "Step into fitness with the Nike Metcon 9 AMP, men's workout shoes in a single color made from sustainable materials.",
      "category": "Sustainable Materials",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Zion 3 \"Gen Zion\"",
      "price": 140.0,
      "imagePath": "lib/asset/images/Shoes (11).png",
      "description":
          "Experience power on the court with Zion 3 \"Gen Zion,\" available in 3 bold colors.",
      "category": "Basketball",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Nike Air Max 1 Premium",
      "price": 136.97,
      "imagePath": "lib/asset/images/Shoes (4).png",
      "description":
          "Step out in style with the Nike Air Max 1 Premium, featuring premium materials and a discount of 14%.",
      "category": "Best Seller",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Nike Air Max 2017",
      "price": 190.0,
      "imagePath": "lib/asset/images/Shoes (7).png",
      "description":
          "Stay on-trend with the Nike Air Max 2017, offering style and comfort in 4 distinct colors.",
      "category": "Just In",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Air Jordan XXXVIII \"Aqua\"",
      "price": 200.0,
      "imagePath": "lib/asset/images/Shoes (16).png",
      "description":
          "Go green with the Air Jordan XXXVIII \"Aqua,\" a basketball shoe made from sustainable materials in 4 colors.",
      "category": "Sustainable Materials",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Air Jordan 1 Zoom CMFT 2",
      "price": 127.97,
      "imagePath": "lib/asset/images/Shoes (2).png",
      "description":
          "Experience comfort and style with the Air Jordan 1 Zoom CMFT 2. A best-seller with 7 color options.",
      "category": "Best Seller",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Nike Blazer Phantom Mid",
      "price": 150.0,
      "imagePath": "lib/asset/images/Shoes (5).png",
      "description":
          "Introducing the Nike Blazer Phantom Mid, a just-in men's shoe available in 2 trendy colors.",
      "category": "Just In",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Air Jordan 4 Craft \"Olive\"",
      "price": 210.0,
      "imagePath": "lib/asset/images/Shoes (3).png",
      "description":
          "The Air Jordan 4 Craft \"Olive\" offers a unique style and premium craftsmanship in a single color option.",
      "category": "Best Seller",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Nike Dunk Low Retro",
      "price": 97.97,
      "imagePath": "lib/asset/images/Shoes (1).png",
      "description":
          "The Nike Dunk Low Retro is a classic men's shoe with a timeless design. Available in 4 colors.",
      "category": "Best Seller",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "KD16 \"B.A.D.\"",
      "price": 160.0,
      "imagePath": "lib/asset/images/Shoes (10).png",
      "description": "Unleash your skills with the KD16 \"B.A.D.,"
          " a basketball shoe with 6 vibrant color options.",
      "category": "Basketball",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "Tiger Woods '13",
      "price": 250.0,
      "imagePath": "lib/asset/images/Shoes (15).png",
      "description":
          "Hit the golf course in style with Tiger Woods '13, men's golf shoes available in 3 classic colors.",
      "category": "Football",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    },
    {
      "name": "LeBron NXXT Gen",
      "price": 144.97,
      "imagePath": "lib/asset/images/Shoes (13).png",
      "description":
          "Upgrade your game with LeBron NXXT Gen, a basketball shoe offering performance and a 14% discount.",
      "category": "Basketball",
      "numberOfItems": 0,
      "pickedTime": 0,
      "sizes": {"Size1": 38, "Size2": 39, "Size3": 40, "Size4": 41, "Size5": 42}
    }
  ];

  int _selectedIndex = 0;

  final _navigationPages = [
    ShopPage(),
    CartPage(),
  ];

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar:
          MyBottomNavBar(onTabChange: (index) => navigateBottomBar(index)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            iconSize: 30,
            color: Colors.black,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              splashRadius: 2,
              icon: Icon(Icons.person_outlined),
              iconSize: 30,
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.only(top: 40),
                    child: Image.asset(
                      'lib/asset/images/Nike.png',
                      width: 180,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.grey[800],
                    ),
                  ),
                  DrawerTile(
                    icon: Icon(Icons.home_rounded), // Pass the desired Icon
                    listName: 'Home',
                  ),
                  DrawerTile(
                    icon: Icon(Icons.info_rounded),
                    listName: "About",
                  ),
                  ElevatedButton(
                    onPressed: () {
                      for (var i = 0; i < products.length; i++) {
                        FirebaseFirestore.instance
                            .collection('shoesCollection')
                            .add(products[i]);
                      }
                    },
                    child: Text(
                      'Add Shoes Data to FireStore',
                    ),
                  ),
                ],
              ),
            ]),
      ),
      body: _navigationPages[_selectedIndex],
    );
  }
}
