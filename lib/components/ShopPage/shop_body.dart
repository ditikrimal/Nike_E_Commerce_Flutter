import 'package:NikeStore/components/CartPage/search_add_to_cart_btn.dart';
import 'package:NikeStore/components/ShopPage/shoe_category.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:NikeStore/pages/UserAuth/login_page.dart';
import 'package:NikeStore/pages/product_detail_page.dart';
import 'package:NikeStore/provider/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShopPageBody extends StatefulWidget {
  final SizedBox shoesList;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final List<Shoe> shoe;

  const ShopPageBody({
    Key? key,
    required this.shoesList,
    required this.searchController,
    required this.onSearch,
    required this.shoe,
  }) : super(key: key);

  @override
  _ShopPageBodyState createState() => _ShopPageBodyState();
}

class _ShopPageBodyState extends State<ShopPageBody> {
  bool isSearching = false;
  CartProvider cartProvider = CartProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[300],
            pinned: true,
            floating: false,
            centerTitle: true,
            titleSpacing: 0,
            collapsedHeight: 70,
            automaticallyImplyLeading: false,
            title: Container(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                padding: const EdgeInsets.fromLTRB(15, 2, 1, 5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.searchController,
                        onChanged: (query) {
                          setState(() {
                            isSearching = query.isNotEmpty;
                          });
                          widget.onSearch(query);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = false;
                        });
                        widget.searchController.clear();
                        FocusScope.of(context).unfocus();
                        widget.onSearch('');
                      },
                      icon: Icon(
                        isSearching ? Icons.close : Icons.search,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                isSearching ? _buildSearchBody() : _buildNormalBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Hot Picks 🔥',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    decoration: TextDecoration.underline),
              )
            ],
          ),
        ),
        widget.shoesList,
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Divider(
            thickness: 1,
            color: Colors.grey[400],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            'Top Categories'.toUpperCase(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        shoesCategory(),
      ],
    );
  }

  Widget _buildSearchBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 15, top: 10),
          alignment: Alignment.center,
          child: Text(
            'where comfort meets fashion, NIKE',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 23.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Search Results',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          children: [
            ...List.generate(
              widget.shoe.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailsPage(
                        shoe: widget.shoe[index],
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
                          widget.shoe[index].imagePath,
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
                            widget.shoe[index].name.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$ ${widget.shoe[index].price.toString()}',
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
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    cartProvider.addToCart(
                                        widget.shoe[index], user.email!, null);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
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
        ),
      ],
    );
  }
}
