// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:NikeStore/authHandle/googleAuth_handle.dart';
import 'package:NikeStore/components/bottom_nav_bar.dart';
import 'package:NikeStore/components/drawer_tiles.dart';
import 'package:NikeStore/pages/cart_page.dart';
import 'package:NikeStore/pages/profile_page.dart';
import 'package:NikeStore/pages/shop_page.dart';
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
                ],
              ),
            ]),
      ),
      body: _navigationPages[_selectedIndex],
    );
  }
}
