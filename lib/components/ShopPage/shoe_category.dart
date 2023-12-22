import 'package:NikeStore/components/ShopPage/shoes_list.dart';
import 'package:NikeStore/pages/category_page.dart';
import 'package:NikeStore/services/shoe_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:NikeStore/components/ShopPage/shoeCategory_tile.dart';
import 'package:NikeStore/provider/shoes_provider.dart';
import 'package:shimmer/shimmer.dart';

ShoeService shoeService = ShoeService();
FutureBuilder<List<String>> shoesCategory() {
  return FutureBuilder<List<String>>(
    future: shoeService.fetchTopCategories(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildshoesCategorySkeleton();
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      List<String>? categories = snapshot.data;
      return _buildshoesCategory(categories!, context);
    },
  );
}

Widget _buildshoesCategory(List categories, BuildContext context) {
  return GridView.count(
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      childAspectRatio: 1,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: categories.map((category) {
        return categoryTile(
          'lib/asset/images/shoes_category/$category.png',
          category,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryPage(
                        categoryName: category,
                      )),
            );
          },
        );
      }).toList());
}

Widget _buildshoesCategorySkeleton() {
  return GridView.count(
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      childAspectRatio: 1,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(6, (index) {
        return Shimmer(
          gradient: shimmerGradient(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              gradient: shimmerGradient(),
              borderRadius: BorderRadius.circular(500),
            ),
            width: 100,
            height: 100,
          ),
        );
      }));
}
