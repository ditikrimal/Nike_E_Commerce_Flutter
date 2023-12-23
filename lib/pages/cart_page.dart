import 'package:NikeStore/components/AuthComponents/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import your Shoe model
import '../components/loading_progress.dart';
import '../models/shoe.dart';
import '../provider/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Initialize to an empty list
  bool isLoading = false;
  final CartProvider _cartProvider = CartProvider();

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
              return cart_page_body(cartList([], isLoading: true),
                  hasData: false);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!_cartProvider.cart.isNotEmpty) {
              return cart_page_body(emptyCart(), hasData: false);
            } else {
              return cart_page_body(cartList(_cartProvider.cart));
            }
          },
        ),
      ),
      if (isLoading) loadingProgress(0)
    ]);
  }

  Widget cart_page_body(SizedBox cartList, {bool hasData = true}) {
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
                  'Your Cart'.toUpperCase(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: hasData
                    ? () async {
                        setState(() {
                          isLoading = true;
                        });
                        await _cartProvider.clearCart(user_email);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      hasData ? Colors.grey[900] : Colors.grey[200]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                child: const Text(
                  'Clear Cart',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10)
            ],
          ),
          const SizedBox(height: 10),
          cartList,
          const Spacer(),
          hasData ? checkoutAndTotal() : SizedBox(),
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
    return Container(
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
                    SizedBox(width: 10),
                    Text(
                      'Size: ${userCart.selectedSize.toString()}',
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
              await _cartProvider.decrementItemInCart(userCart.id, user_email);
              setState(() {
                isLoading = false;
              });
            },
            icon: Icon(Icons.remove),
          ),
          Text(
            '${userCart.numberOfItems}',
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
              await _cartProvider.incrementItemInCart(userCart.id, user_email);
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
              await _cartProvider.removeFromCart(userCart.id, user_email);
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

  Widget checkoutAndTotal() {
    return Center(
      child: AuthButton(
        onTap: () {},
        buttonLabel: 'PROCEED TO CHECKOUT',
        buttonWidth: MediaQuery.of(context).size.width / 1.2,
        vericalPadding: 14,
        radius: 6,
        fontSize: 19,
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
