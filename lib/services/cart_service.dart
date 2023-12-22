import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shoe.dart';

class CartService {
  void addToCart(Shoe shoe, String email) {
    addToFirestore(shoe, email);
  }

  void removeFromCart(Shoe shoe, String email) {
    removeFromFirestore(shoe.shoeID, email);
  }

  void clearCart(String email) {
    clearFirestoreCart(email);
  }

  Future<List<Shoe>> getCurrentUserCart(String email) async {
    List<Shoe> userCart = []; // Local list to store cart items

    var cartSnapshot = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .get();

    for (var doc in cartSnapshot.docs) {
      Map<String, dynamic> data = doc.data()!;
      DocumentReference shoeRef = data['shoeRef'];
      var shoeDoc = await shoeRef.get();

      if (shoeDoc.exists) {
        userCart.add(Shoe(
          shoeID: doc.id,
          name: shoeDoc['name'] ?? '',
          price: (shoeDoc['price']).toDouble() ?? 0.0,
          imagePath: shoeDoc['imagePath'] ?? '',
          description: shoeDoc['description'] ?? 'Description',
          numberOfItems: data['numberOfItems'] ?? 1,
          category: shoeDoc['category'] ?? 'Category',
        ));
      }
    }

    return userCart;
  }

  Future<void> addToFirestore(Shoe shoe, String email) async {
    final cartItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(shoe.shoeID);

    final cartItemDoc = await cartItemRef.get();

    if (cartItemDoc.exists) {
      // If the item exists, update the quantity
      await cartItemRef.update({
        'numberOfItems': (cartItemDoc.data()!['numberOfItems'] ?? 0) + 1,
        'addedAt': DateTime.now(),
        // You can add other fields that need updating
      });
    } else {
      // If the item doesn't exist, create a new cart item with a reference to the shoe
      final shoeRef = FirebaseFirestore.instance
          .collection('shoesCollection')
          .doc(shoe.shoeID);

      await cartItemRef.set({
        'shoeRef': shoeRef, // Assign a valid DocumentReference to 'shoeRef'
        'addedAt': DateTime.now(),
        'numberOfItems': 1,
        // Add other product details as needed
      });
    }
  }

  Future<void> incrementItemInFirestore(String shoeId, String? email) async {
    final cartItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(shoeId);

    final cartItemDoc = await cartItemRef.get();

    if (cartItemDoc.exists) {
      // If the item exists, update the quantity
      await cartItemRef.update({
        'numberOfItems': (cartItemDoc.data()!['numberOfItems'] ?? 0) + 1,
        'addedAt': DateTime.now(),
        // You can add other fields that need updating
      });
    }
  }

  Future<void> decrementItemInFirestore(String shoeId, String? email) async {
    final cartItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(shoeId);

    final cartItemDoc = await cartItemRef.get();

    if (cartItemDoc.exists) {
      if (cartItemDoc.data()!['numberOfItems'] == 1) {
        await cartItemRef.delete();
        return;
      }
      await cartItemRef.update({
        'numberOfItems': (cartItemDoc.data()!['numberOfItems'] ?? 0) - 1,
        'addedAt': DateTime.now(),
        // You can add other fields that need updating
      });
    }
  }

  Future removeFromFirestore(String shoeId, String? email) async {
    await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(shoeId)
        .delete();
  }

  Future clearFirestoreCart(String email) async {
    // Delete the entire cart collection for the user
    var cartSnapshot = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .get();

    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future addToWishlist(Shoe shoe, String? email) async {
    final wishListItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('wishlist')
        .doc(shoe.shoeID);
    final wishListItemDoc = await wishListItemRef.get();
    if (wishListItemDoc.exists) {
      return;
    } else {
      // If the item doesn't exist, create a new cart item with a reference to the shoe
      final shoeRef = FirebaseFirestore.instance
          .collection('shoesCollection')
          .doc(shoe.shoeID);

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
        .doc(shoe.shoeID);

    final cartItemDoc = await wishListItemRef.get();

    return cartItemDoc.exists;
  }

  Future removeFromWishlist(Shoe shoe, String? email) async {
    await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('wishlist')
        .doc(shoe.shoeID)
        .delete();
  }
}
