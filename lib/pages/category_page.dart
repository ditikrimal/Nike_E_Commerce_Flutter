import 'package:NikeStore/components/CartPage/search_add_to_cart_btn.dart';
import 'package:NikeStore/components/back_button.dart';
import 'package:NikeStore/components/my-appbar.dart';
import 'package:NikeStore/pages/UserAuth/login_page.dart';
import 'package:NikeStore/pages/product_detail_page.dart';
import 'package:NikeStore/provider/cart_provider.dart';
import 'package:NikeStore/provider/shoes_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  CartProvider cartProvider = CartProvider();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<ShoeProvider>(context, listen: false)
          .fetchShoesByCategory(widget.categoryName);
    });
  }

  @override
  void dispose() {
    Provider.of<ShoeProvider>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: myAppBar(context, widget.categoryName.toUpperCase(),
            cartOption: true),
        body: Consumer<ShoeProvider>(builder: (context, shoeProvider, _) {
          return RefreshIndicator(
            color: Colors.black,
            onRefresh: () async {
              await Provider.of<ShoeProvider>(context, listen: false)
                  .fetchShoesByCategory(widget.categoryName);
            },
            child: FutureBuilder(
              future: shoeProvider.shoesByCategory.isNotEmpty
                  ? null
                  : shoeProvider.fetchShoesByCategory(widget.categoryName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    children: [
                      ...List.generate(
                        shoeProvider.shoesByCategory.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProductDetailsPage(
                                  shoe: shoeProvider.shoesByCategory[index],
                                );
                              }));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    shoeProvider
                                        .shoesByCategory[index].imagePath,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      shoeProvider.shoesByCategory[index].name
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '\$ ${shoeProvider.shoesByCategory[index].price.toString()}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AddToCartButtonSearch(
                                          onTap: () {
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            if (user != null) {
                                              cartProvider.addToCart(
                                                  shoeProvider
                                                      .shoesByCategory[index],
                                                  user.email!,
                                                  null);
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()),
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
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          );
        }));
  }
}
