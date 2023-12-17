import 'package:cloud_firestore/cloud_firestore.dart';

class Shoe {
  final String name;
  final String price;
  final String imagePath;
  final String description;
  Shoe({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
  });
}

Future<List<Shoe>> fetchShoesFromFirestore() async {
  // Replace 'shoesCollection' with your Firestore collection name
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('shoesCollection').get();

  return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Shoe(
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
    );
  }).toList();
}
