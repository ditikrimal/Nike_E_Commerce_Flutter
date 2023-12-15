// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nike_e_commerce/pages/home_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Image.asset(
                'lib/images/Shoes.png',
                height: 200,
              ),
            ),
            Text(
              'Just Do It',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Brand new sneakers and custom kicks made with premium quality',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 60, 60, 60),
                  fontSize: 19,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ActionChip(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: 120,
                vertical: 14,
              ),
              label: Text(
                'Shop Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              avatar: Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
