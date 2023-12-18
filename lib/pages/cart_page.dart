// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/loading_progress.dart';
import 'package:nike_e_commerce/models/cart.dart';
import 'package:nike_e_commerce/models/shoe.dart'; // Import your Shoe model

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Shoe>> userCart;
  bool isLoading = false;

  @override
  final user_email = FirebaseAuth.instance.currentUser!.email!;
  @override
  void initState() {
    super.initState();
    refreshUserCart();
  }

  void refreshUserCart() {
    setState(() {
      isLoading = true;
    });

    userCart = getCurrentUserCart(user_email).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _onIncrementPressed(Shoe shoe) async {
    // Show loading overlay
    setState(() {
      isLoading = true;
    });

    try {
      // Perform increment operation
      await incrementItemInFirestore(shoe.shoeID, user_email);

      // Refresh user cart
      refreshUserCart();
    } catch (error) {
      print("Error: $error");
      // Handle the error as needed
    } finally {
      // Hide loading overlay
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onDecrementPressed(Shoe shoe) async {
    // Show loading overlay
    setState(() {
      isLoading = true;
    });

    try {
      // Perform increment operation
      await decrementItemInFirestore(shoe.shoeID, user_email);

      // Refresh user cart
      refreshUserCart();
    } catch (error) {
      print("Error: $error");
      // Handle the error as needed
    } finally {
      // Hide loading overlay
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onRemovePressed(Shoe shoe) async {
    // Show loading overlay
    setState(() {
      isLoading = true;
    });

    try {
      // Perform increment operation
      await removeFromFirestore(shoe.shoeID, user_email);

      // Refresh user cart
      refreshUserCart();
    } catch (error) {
      print("Error: $error");
      // Handle the error as needed
    } finally {
      // Hide loading overlay
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isLoading);
    return Stack(children: [
      FutureBuilder(
        future: userCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return cart_page_body(cartList([], isLoading: true));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Shoe> userCart = snapshot.data!;
            if (userCart.isNotEmpty) {
              // Show the cart body when there are items in the cart
              return cart_page_body(
                cartList(userCart),
              );
            } else {
              return cart_page_body(emptyCart());
            }
          } else {
            // Show the loading indicator
            return cart_page_body(cartList([], isLoading: false));
          }
        },
      ),
      if (isLoading) loadingProgress()
    ]);
  }

  Widget cart_page_body(SizedBox cartList) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Your Cart'.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          cartList,
          Spacer(),
        ],
      ),
    );
  }

  SizedBox cartList(List<Shoe> shoes, {bool isLoading = false}) {
    return SizedBox(
      height: 450,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: isLoading ? 3 : shoes.length,
          itemBuilder: (context, index) {
            return isLoading
                ? _skeltonLoader()
                : cart_tile(
                    shoes[index],
                    shoes,
                  );
          },
        ),
      ),
    );
  }

  Widget cart_tile(
    Shoe shoe,
    List<Shoe> userCart,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            shoe.imagePath,
            height: 70,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shoe.name,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$ ${shoe.price}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              _onDecrementPressed(shoe);
            },
            icon: Icon(Icons.remove),
          ),
          Text(
            '${shoe.numberOfItems}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              _onIncrementPressed(shoe);
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              _onRemovePressed(shoe);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  SizedBox emptyCart() {
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            SizedBox(height: 10),
            Text(
              'Empty',
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
