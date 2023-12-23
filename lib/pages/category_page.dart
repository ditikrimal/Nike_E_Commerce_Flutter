import 'package:NikeStore/components/back_button.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.grey[300],
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              categoryName.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          leading: backArrow(context),
        ),
        body: Center(
          child: Text('Category Page of $categoryName'),
        ));
  }
}
