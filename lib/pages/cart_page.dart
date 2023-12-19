import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/loading_progress.dart';
import '../models/cart.dart';
import '../models/shoe.dart';
import '../provider/cart_provider.dart';
import 'package:provider/provider.dart'; // Import your Shoe model

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Initialize to an empty list
  bool isLoading = false;
  UserCartProvider cartProvider = UserCartProvider();
  CartProvider _cartProvider = CartProvider();
  final user_email = FirebaseAuth.instance.currentUser!.email!;
  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).fetchCart(user_email);
  }

  Future<void> _refreshCart() async {
    await Provider.of<CartProvider>(context, listen: false)
        .fetchCart(user_email);
  }

  @override
  Widget build(BuildContext context) {
    print(isLoading);
    return Stack(children: [
      RefreshIndicator(
        onRefresh:
            _refreshCart, // Specify the function to call on pull-to-refresh
        child: FutureBuilder(
          future: _cartProvider.cart.isNotEmpty
              ? null
              : _cartProvider.fetchCart(user_email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return cart_page_body(cartList([], isLoading: true));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!_cartProvider.cart.isNotEmpty) {
              return cart_page_body(emptyCart());
            } else {
              return cart_page_body(cartList(_cartProvider.cart));
            }
          },
        ),
      ),
      if (isLoading) loadingProgress(0)
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
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await _cartProvider.decrementItemInCart(shoe.shoeID, user_email);
              setState(() {
                isLoading = false;
              });
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
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await _cartProvider.incrementItemInCart(shoe.shoeID, user_email);
              setState(() {
                isLoading = false;
              });
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await _cartProvider.removeFromCart(shoe.shoeID, user_email);
              setState(() {
                isLoading = false;
              });
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
            SizedBox(height: 50),
            Icon(
              Icons.shopping_bag_outlined,
              size: 100,
              color: Colors.grey[700],
            ),
            SizedBox(height: 10),
            Text(
              'Empty'.toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
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
