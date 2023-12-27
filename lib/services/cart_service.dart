import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/shoe.dart';

class CartService {
  Future<List<Shoe>> getCurrentUserCart(String email) async {
    List<Shoe> userCart = []; // Local list to store cart items

    var cartSnapshot = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .get();

    for (var doc in cartSnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      DocumentReference shoeRef = data['shoeRef'];
      var shoeDoc = await shoeRef.get();

      if (shoeDoc.exists) {
        userCart.add(Shoe(
          id: doc.id,
          name: shoeDoc['name'] ?? '',
          price: (shoeDoc['price']).toDouble() ?? 0.0,
          imagePath: shoeDoc['imagePath'] ?? '',
          description: shoeDoc['description'] ?? 'Description',
          category: shoeDoc['category'] ?? 'Category',
          numberOfItems: data['numberOfItems'] ?? 1,
          pickedItems: data['pickedItems'] ?? 0,
          sizes: Map<String, int>.from(shoeDoc['sizes']),
          selectedSize: data['selectedSize'] ?? '', // Include selectedSize
        ));
      }
    }
    return userCart;
  }

  Future<void> addToFirestore(
      Shoe shoe, String email, int? selectedSize) async {
    final cartCollection = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart');

    final shoeRef =
        FirebaseFirestore.instance.collection('shoesCollection').doc(shoe.id);

    final existingCartItemQuery = await cartCollection
        .where('shoeRef', isEqualTo: shoeRef)
        .where('selectedSize', isEqualTo: selectedSize)
        .get();

    if (existingCartItemQuery.docs.isNotEmpty) {
      // If the item exists with the same shoe and size, update the quantity
      final existingCartItem = existingCartItemQuery.docs.first;
      await existingCartItem.reference.update({
        'numberOfItems': (existingCartItem['numberOfItems'] ?? 0) + 1,
        'addedAt': DateTime.now(),
        // You can add other fields that need updating
      });
    } else {
      // If the item doesn't exist or has a different size, create a new cart item
      await cartCollection.add({
        'shoeRef': shoeRef,
        'addedAt': DateTime.now(),
        'numberOfItems': 1,
        'selectedSize': selectedSize ?? 40,
        // Add other product details as needed
      });
    }
  }

  Future<void> incrementItemInFirestore(String id, String? email) async {
    final cartItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(id);

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

  Future<void> decrementItemInFirestore(String id, String? email) async {
    final cartItemRef = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(id);

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

  Future<num> getCartItemCount(String email) async {
    num totalItemCount = 0;
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
        totalItemCount = totalItemCount + data['numberOfItems'];
      }
    }
    return totalItemCount;
  }

  Future<double> calculateTotalPrice(String email) async {
    double total = 0;
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
        total += (shoeDoc['price']).toDouble() * data['numberOfItems'];
      }
    }
    return total;
  }

  Future removeFromFirestore(String id, String? email) async {
    await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .collection('cart')
        .doc(id)
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
