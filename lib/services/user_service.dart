import 'package:NikeStore/models/shoe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<List<Shoe>> fetchWishList(String email) async {
    List<Shoe> wishlist = []; // Local list to store cart items

    var wishlistSnapshot = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('wishlist')
        .get();

    for (var doc in wishlistSnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      DocumentReference shoeRef = data['shoeRef'];
      var shoeDoc = await shoeRef.get();
      print(shoeDoc['sizes'].runtimeType);

      if (shoeDoc.exists) {
        Map<String, dynamic> sizesMap = shoeDoc['sizes'];
        Map<String, int> sizes =
            sizesMap.map((key, value) => MapEntry(key, value as int));

        wishlist.add(Shoe(
          id: doc.id,
          name: shoeDoc['name'] ?? '',
          price: (shoeDoc['price']).toDouble() ?? 0.0,
          imagePath: shoeDoc['imagePath'] ?? '',
          description: shoeDoc['description'] ?? 'Description',
          category: shoeDoc['category'] ?? 'Category',
          numberOfItems: data['numberOfItems'] ?? 1,
          pickedItems: data['pickedItems'] ?? 0,
          sizes: sizes,
          // Include selectedSize
        ));
      }
    }
// Existing code...

    return wishlist;
  }

  Future addToWishlist(Shoe shoe, String? email) async {
    final wishListItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('wishlist')
        .doc(shoe.id);
    final wishListItemDoc = await wishListItemRef.get();
    if (wishListItemDoc.exists) {
      return;
    } else {
      // If the item doesn't exist, create a new cart item with a reference to the shoe
      final shoeRef =
          FirebaseFirestore.instance.collection('shoesCollection').doc(shoe.id);

      await wishListItemRef.set({
        'shoeRef': shoeRef, // Assign a valid DocumentReference to 'shoeRef'
        'addedAt': DateTime.now(),
        'numberOfItems': 1,
        // Add other product details as needed
      });
    }
  }

  Future<bool> checkWishList(Shoe shoe, String? email) async {
    final wishListItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('wishlist')
        .doc(shoe.id);

    final cartItemDoc = await wishListItemRef.get();

    return cartItemDoc.exists;
  }

  Future removeFromWishlist(Shoe shoe, String? email) async {
    await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('wishlist')
        .doc(shoe.id)
        .delete();
  }
}
