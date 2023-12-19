import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final String shoeID;
  final String name;
  final String price;
  final String imagePath;
  final String description;
  final int numberOfItems;
  Shoe({
    required this.shoeID,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    this.numberOfItems = 1,
  });
}
