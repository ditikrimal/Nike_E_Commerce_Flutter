import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shoe.dart';

class ShoeService {
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
        numberOfItems: data['numberOfItems'] ?? 0,
      );
    }).toList();
  }
}
