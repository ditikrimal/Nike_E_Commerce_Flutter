// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/bottom_nav_bar.dart';
import 'package:nike_e_commerce/components/drawer_tiles.dart';
import 'package:nike_e_commerce/pages/cart_page.dart';
import 'package:nike_e_commerce/pages/shop_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void navigateBottomBar(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _navigationPages = [
    ShopPage(),
    CartPage(),
  ];

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
                    'lib/images/NikeLogo.png',
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: DrawerTile(
                icon: Icon(Icons.logout_rounded),
                listName: "Logout",
              ),
            ),
          ],
        ),
      ),
      body: _navigationPages[_selectedIndex],
    );
  }
}
