import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shoe.dart';

class ShoeService {
  Future<List<Shoe>> fetchShoesFromFirestoreByCategory(String category) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('shoesCollection')
        .where('category',
            isEqualTo: category) // Add this line for category filtering
        .get();

    return snapshot.docs.map((DocumentSnapshot<Map<dynamic, dynamic>> doc) {
      Map<dynamic, dynamic> data = doc.data()!;
      return Shoe(
        shoeID: doc.id,
        name: data['name'] ?? '',
        price: data['price'] ?? 0.0,
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 0,
      );
    }).toList();
  }

  Future<List<Shoe>> fetchShoesFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('shoesCollection').get();

    return snapshot.docs.map((DocumentSnapshot<Map<dynamic, dynamic>> doc) {
      Map<dynamic, dynamic> data = doc.data()!;
      return Shoe(
        shoeID: doc.id,
        name: data['name'] ?? '',
        price: (data['price'] ?? 0.0).toDouble(),
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 0,
      );
    }).toList();
  }

  Future<List<String>> fetchTopCategories() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('shoesCollection')
        .orderBy('pickedTimes', descending: true)
        .limit(6)
        .get();

    List<String> topCategories = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      String category = doc['category'];
      if (!topCategories.contains(category)) {
        topCategories.add(category);
      }
    }

    return topCategories;
  }

  Future<List<Shoe>> fetchHotPicks() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('shoesCollection')
        .orderBy('pickedTimes', descending: true)
        .limit(6)
        .get();

    return snapshot.docs.map((DocumentSnapshot<Map<dynamic, dynamic>> doc) {
      Map<dynamic, dynamic> data = doc.data()!;
      return Shoe(
        shoeID: doc.id,
        name: data['name'] ?? '',
        price: (data['price']).toDouble() ?? 0.0,
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 0,
      );
    }).toList();
  }
}
