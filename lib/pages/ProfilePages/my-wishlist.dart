import 'package:NikeStore/components/loading_progress.dart';
import 'package:NikeStore/components/my-appbar.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:NikeStore/pages/product_detail_page.dart';
import 'package:NikeStore/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import your Shoe model

class MyWishlist extends StatefulWidget {
  const MyWishlist({Key? key}) : super(key: key);

  @override
  _MyWishlistState createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlist> {
  // Initialize to an empty list
  bool isLoading = false;

  final UserProvider _userProvider = UserProvider();

  final user_email = FirebaseAuth.instance.currentUser!.email!;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchWishList(user_email);
  }

  Future<void> _refreshCart() async {
    await Provider.of<UserProvider>(context, listen: false)
        .fetchWishList(user_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: myAppBar(context, ''),
        body: Stack(children: [
          RefreshIndicator(
            onRefresh:
                _refreshCart, // Specify the function to call on pull-to-refresh
            child: FutureBuilder(
              future: _userProvider.wishlistShoes.isNotEmpty
                  ? null
                  : _userProvider.fetchWishList(user_email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return cart_page_body(
                    cartList([], isLoading: true),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!_userProvider.wishlistShoes.isNotEmpty) {
                  return cart_page_body(emptyCart());
                } else {
                  return cart_page_body(cartList(_userProvider.wishlistShoes));
                }
              },
            ),
          ),
          if (isLoading) loadingProgress(0)
        ]));
  }

  Widget cart_page_body(SizedBox cartList) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'My Wishlist'.toUpperCase(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              SizedBox(width: 10)
            ],
          ),
          const SizedBox(height: 10),
          cartList,
          const Spacer(),
        ],
      ),
    );
  }

  SizedBox cartList(List<Shoe> cart, {bool isLoading = false}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.62,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: isLoading ? 3 : cart.length,
          itemBuilder: (context, index) {
            return isLoading
                ? _skeltonLoader()
                : cart_tile(
                    cart[index],
                  );
          },
        ),
      ),
    );
  }

  Widget cart_tile(Shoe userCart) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              shoe: userCart,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(
              userCart.imagePath,
              height: 70,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userCart.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$ ${userCart.price.toString()}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await _userProvider.removeFromWishlist(userCart, user_email);
                setState(() {
                  isLoading = false;
                });
              },
              icon: Icon(Icons.favorite, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox emptyCart() {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Icon(
              Icons.heart_broken,
              size: 100,
              color: Colors.grey[400],
            ),
            SizedBox(height: 10),
            Text(
              'Empty'.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Container _skeltonLoader() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(5),
          width: 70,
          height: 50,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              width: 100,
              color: Colors.grey[300],
            ),
            SizedBox(height: 5),
            Container(
              height: 15,
              width: 50,
              color: Colors.grey[300],
            ),
          ],
        ),
      ],
    ),
  );
}
