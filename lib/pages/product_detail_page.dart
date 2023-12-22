import 'package:NikeStore/components/alert_snackbar.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:NikeStore/pages/home_page.dart';
import 'package:NikeStore/provider/cart_provider.dart';
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
  late Future<bool> _isWishListed;

  CartProvider _cartProvider = CartProvider();

  @override
  void initState() {
    _isWishListed = _cartProvider.checkWishList(
        widget.shoe, FirebaseAuth.instance.currentUser!.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          iconSize: 30,
        ),
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
                    if (isLiked) {
                      await _cartProvider.removeFromWishlist(widget.shoe,
                          FirebaseAuth.instance.currentUser!.email);
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomAlertBar.info(
                          messageStatus: 'Removed from Wishlist',
                          message: 'Item has been removed from your wishlist.',
                        ),
                      );
                    } else {
                      await _cartProvider.addToWishlist(widget.shoe,
                          FirebaseAuth.instance.currentUser!.email);
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomAlertBar.info(
                          messageStatus: 'Added to Wishlist',
                          message: 'Item has been added to your wishlist.',
                        ),
                      );
                    }
                    setState(() {
                      _isWishListed = _cartProvider.checkWishList(widget.shoe,
                          FirebaseAuth.instance.currentUser!.email);
                    });
                    return !isLiked;
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
      body: Container(),
    );
  }
}
