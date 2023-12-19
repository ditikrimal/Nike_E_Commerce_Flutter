import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final String shoeID;
  final String name;
  final int price;
  final String imagePath;
  final String description;
  final String category;
  final int numberOfItems;
  Shoe({
    required this.shoeID,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.category,
    this.numberOfItems = 1,
  });
}
