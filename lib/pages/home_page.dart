// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nike_e_commerce/authHandle/googleAuth_handle.dart';
import 'package:nike_e_commerce/components/alert_snackbar.dart';
import 'package:nike_e_commerce/components/bottom_nav_bar.dart';
import 'package:nike_e_commerce/components/drawer_tiles.dart';
import 'package:nike_e_commerce/pages/cart_page.dart';
import 'package:nike_e_commerce/pages/profile_page.dart';
import 'package:nike_e_commerce/pages/shop_page.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final GoogleAuthHandle _authService = GoogleAuthHandle();

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
                    'lib/images/Nike.png',
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
              child: ElevatedButton(
                onPressed: () async {
                  // Trigger Google Sign-In
                  await _authService.signOut();
                  Navigator.pop(context);
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomAlertBar.success(
                      messageStatus: 'Success',
                      message: 'Logged Out successfully',
                    ),
                  );
                },
                child: Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      body: _navigationPages[_selectedIndex],
    );
  }
}
