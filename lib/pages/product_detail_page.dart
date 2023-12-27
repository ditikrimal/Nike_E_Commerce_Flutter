import 'package:NikeStore/authHandle/email_handle.dart';
import 'package:NikeStore/components/CartPage/add_to_cart_btn.dart';
import 'package:NikeStore/components/alert_snackbar.dart';
import 'package:NikeStore/components/back_button.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:NikeStore/pages/UserAuth/login_page.dart';
import 'package:NikeStore/pages/UserAuth/verifyemail_page.dart';
import 'package:NikeStore/pages/home_page.dart';
import 'package:NikeStore/provider/cart_provider.dart';
import 'package:NikeStore/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProductDetailsPage extends StatefulWidget {
  final Shoe shoe;

  const ProductDetailsPage({Key? key, required this.shoe}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? selectedSize;
  int selectedSizeValue = 40;

  late Future<bool> _isWishListed = Future.value(false);

  UserProvider _userProvider = UserProvider();
  CartProvider _cartProvider = CartProvider();

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _isWishListed = _userProvider.checkWishList(
          widget.shoe, FirebaseAuth.instance.currentUser!.email);
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: backArrow(context),
        actions: [
          FutureBuilder<bool>(
            future: _isWishListed,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LikeButton(); // You can replace this with a loading indicator if needed
              } else {
                bool isWishListed = snapshot.data ?? false;
                return LikeButton(
                  isLiked: isWishListed,
                  onTap: (bool isLiked) async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      if (user.emailVerified || await checkEmail(user.email)) {
                        if (isLiked) {
                          await _userProvider.removeFromWishlist(widget.shoe,
                              FirebaseAuth.instance.currentUser!.email);
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomAlertBar.info(
                              messageStatus: 'Removed from Wishlist',
                              message:
                                  'Item has been removed from your wishlist.',
                            ),
                          );
                        } else {
                          await _userProvider.addToWishlist(
                              widget.shoe, user.email);
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomAlertBar.info(
                              messageStatus: 'Added to Wishlist',
                              message: 'Item has been added to your wishlist.',
                            ),
                          );
                        }
                        setState(() {
                          _isWishListed = _userProvider.checkWishList(
                              widget.shoe, user.email);
                        });
                        return !isLiked;
                      } else {
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
                );
              }
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    initialPageIndex: 1,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black,
            ),
            iconSize: 30,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image(
                image: AssetImage(widget.shoe.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(25),
                  topEnd: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shoe.name,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '\$ ${widget.shoe.price.toString()}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.shoe.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select size',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            for (var size in widget.shoe.sizes.entries.toList())
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: selectedSize == size.value.toString()
                                      ? Colors.grey[
                                          800] // Change color for selected size
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton(
                                  child: Text(
                                    size.value.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: selectedSize ==
                                              size.value.toString()
                                          ? Colors
                                              .white // Change text color for selected size
                                          : Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedSize = size.value.toString();
                                      selectedSizeValue = size.value;
                                    });
                                    // You can add more logic here when a size is selected
                                  },
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add to cart'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        AddToCartButton(
                            disableAnimation:
                                (selectedSize != null) ? false : true,
                            onTap: (selectedSize != null)
                                ? () async {
                                    await addToCartAuth(context);
                                  }
                                : () {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomAlertBar.info(
                                        messageStatus: 'Size',
                                        message: 'Please select a size',
                                      ),
                                    );
                                  }),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addToCartAuth(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (await checkEmail(user.email)) {
        print('this is $selectedSizeValue');
        _cartProvider.addToCart(widget.shoe, user.email!, selectedSizeValue);
        showTopSnackBar(
          Overlay.of(context),
          const CustomAlertBar.info(
            messageStatus: 'Cart',
            message: 'Item has been added to your Cart',
          ),
        );
        setState(() {
          selectedSize = null;
        });
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomAlertBar.info(
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
  }
}
