// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:NikeStore/authHandle/email_handle.dart';
import 'package:NikeStore/components/CartPage/add_to_cart_btn.dart';
import 'package:NikeStore/components/alert_snackbar.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:NikeStore/pages/UserAuth/login_page.dart';
import 'package:NikeStore/pages/UserAuth/verifyemail_page.dart';
import 'package:NikeStore/pages/product_detail_page.dart';
import 'package:NikeStore/provider/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ShoeTile extends StatelessWidget {
  final Shoe shoe;

  ShoeTile({super.key, required this.shoe});
  // final user = AuthService.firebase().currentUser;
  CartProvider cartProvider = CartProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetailsPage(
            shoe: shoe,
          );
        }));
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 12, right: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              shoe.imagePath,
              height: 220,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  shoe.name,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                shoe.description,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${shoe.price.toString()}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AddToCartButton(
                    onTap: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        if (await checkEmail(user.email)) {
                          cartProvider.addToCart(shoe, user.email!, null);
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomAlertBar.info(
                              messageStatus: 'Cart',
                              message: 'Item has been added to your Cart',
                            ),
                          );
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomAlertBar.info(
                              messageStatus: 'Email',
                              message: 'Verify email to continue shopping',
                            ),
                          );
                          user.sendEmailVerification();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VeryEmailPage(),
                            ),
                          );
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
