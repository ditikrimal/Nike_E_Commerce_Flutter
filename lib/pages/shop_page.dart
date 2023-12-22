import 'package:NikeStore/components/ShopPage/shop_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/ShopPage/shoes_list.dart';
import '../provider/shoes_provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ShoeProvider>(context, listen: false).fetchHotPicks();
    });
  }

  TextEditingController _searchController = TextEditingController();

  void _handleSearch(String query, ShoeProvider shoeProvider) {
    final filteredShoes = shoeProvider.hotPicks
        .where((shoe) => shoe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      shoeProvider.filteredShoes = filteredShoes;
      shoeProvider.searchQuery = query;
    });
  }

  Future<void> _refreshShoes() async {
    await Provider.of<ShoeProvider>(context, listen: false).fetchHotPicks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoeProvider>(
      builder: (context, shoeProvider, _) {
        return RefreshIndicator(
          color: Colors.black,
          onRefresh: _refreshShoes,
          child: FutureBuilder(
            future: shoeProvider.hotPicks.isNotEmpty
                ? null
                : shoeProvider.fetchHotPicks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShopPageBody(
                  shoesList: shoeList([], isLoading: true),
                  searchController: _searchController,
                  onSearch: (query) => _handleSearch(query, shoeProvider),
                  shoe: [],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!shoeProvider.hotPicks.isNotEmpty) {
                return emptyShoesList();
              } else {
                final bool noShoesFound = shoeProvider.filteredShoes.isEmpty;
                if (noShoesFound) {
                  return ShopPageBody(
                    shoesList: emptyShoesList(),
                    searchController: _searchController,
                    onSearch: (query) => _handleSearch(query, shoeProvider),
                    shoe: shoeProvider.searchQuery.isEmpty
                        ? shoeProvider.hotPicks
                        : shoeProvider.filteredShoes,
                  );
                }

                return ShopPageBody(
                  shoesList: shoeList(shoeProvider.searchQuery.isEmpty
                      ? shoeProvider.hotPicks
                      : shoeProvider.filteredShoes),
                  searchController: _searchController,
                  onSearch: (query) => _handleSearch(query, shoeProvider),
                  shoe: shoeProvider.searchQuery.isEmpty
                      ? shoeProvider.shoes
                      : shoeProvider.filteredShoes,
                );
              }
            },
          ),
        );
      },
    );
  }
}
