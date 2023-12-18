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

Future<List<Shoe>> fetchShoesFromFirestore() async {
  // Replace 'shoesCollection' with your Firestore collection name
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('shoesCollection').get();

  return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Shoe(
      shoeID: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
    );
  }).toList();
}
