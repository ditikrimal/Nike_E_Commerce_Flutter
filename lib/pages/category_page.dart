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
              'Category: $categoryName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.black,
            iconSize: 32,
          ),
        ),
        body: Center(
          child: Text('Category Page of $categoryName'),
        ));
  }
}
