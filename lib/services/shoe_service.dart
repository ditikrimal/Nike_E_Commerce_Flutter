import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shoe.dart';

class ShoeService {
  Future<List<Shoe>> fetchShoesFromFirestore() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('shoesCollection').get();

    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> data = doc.data()!;
      Map<String, int> sizes = Map<String, int>.from(data['size'] ?? {});

      return Shoe(
        id: doc.id,
        name: data['name'] ?? '',
        price: (data['price'] ?? 0.0).toDouble(),
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 0,
        pickedItems: data['pickedItems'] ?? 0,
        sizes: sizes,
      );
    }).toList();
  }

  Future<List<Shoe>> fetchShoesByCategory(String category) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('shoesCollection')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> data = doc.data()!;
      Map<String, int> sizes = Map<String, int>.from(data['size'] ?? {});

      return Shoe(
        id: doc.id,
        name: data['name'] ?? '',
        price: (data['price'] ?? 0.0).toDouble(),
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 0,
        pickedItems: data['pickedItems'] ?? 0,
        sizes: sizes,
      );
    }).toList();
  }

  Future<List<String>> fetchTopCategories() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('shoesCollection')
        .orderBy('pickedTime', descending: true)
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
        .orderBy('pickedTime', descending: true)
        .limit(6)
        .get();

    return snapshot.docs.map((DocumentSnapshot<Map<dynamic, dynamic>> doc) {
      Map<dynamic, dynamic> data = doc.data()!;
      Map<String, int> sizes = Map<String, int>.from(data['sizes'] ?? {});

      return Shoe(
        id: doc.id,
        name: data['name'] ?? '',
        price: (data['price']).toDouble() ?? 0.0,
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 0,
        sizes: data['sizes'] is Map ? Map<String, int>.from(data['sizes']) : {},
      );
    }).toList();
  }
}
