import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/shoe.dart';
import '../services/cart_service.dart';

class UserCartProvider with ChangeNotifier {
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
      userCart.add(Shoe(
        shoeID: doc.id,
        name: data['name'] ?? '',
        price: data['price'] ?? '',
        imagePath: data['imagePath'] ?? '',
        description: data['description'] ?? '',
        numberOfItems: data['numberOfItems'] ?? 1,
      ));
    }

    return userCart;
  }

  void addToFirestore(Shoe shoe, String email) async {
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
      // If the item doesn't exist, create a new cart item
      await cartItemRef.set({
        'name': shoe.name,
        'price': shoe.price,
        'imagePath': shoe.imagePath,
        'addedAt': DateTime.now(),
        'numberOfItems': 1,
        // Add other product details as needed
      });
    }
  }

  Future incrementItemInFirestore(String shoeId, String? email) async {
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

  Future decrementItemInFirestore(String shoeId, String? email) async {
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
}

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  List<Shoe> _userCart = [];

  List<Shoe> get cart => _userCart;

  Future<void> fetchCart(String email) async {
    _userCart = await _cartService.getCurrentUserCart(email);
    notifyListeners();
  }

  Future<void> addToCart(Shoe shoe, String email) async {
    await _cartService.addToFirestore(shoe, email);
    await fetchCart(email);
  }

  Future<void> incrementItemInCart(String shoeId, String email) async {
    await _cartService.incrementItemInFirestore(shoeId, email);
    await fetchCart(email);
  }

  Future<void> decrementItemInCart(String shoeId, String email) async {
    await _cartService.decrementItemInFirestore(shoeId, email);
    await fetchCart(email);
  }

  Future<void> removeFromCart(String shoeId, String email) async {
    await _cartService.removeFromFirestore(shoeId, email);
    await fetchCart(email);
  }
}
