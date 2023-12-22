import 'package:flutter/material.dart';

import '../models/shoe.dart';
import '../services/cart_service.dart';

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

  Future<bool> checkWishList(Shoe shoe, String? email) {
    return _cartService.checkWishList(shoe, email);
  }

  Future<void> addToWishlist(Shoe shoe, String? email) async {
    await _cartService.addToWishlist(shoe, email);
  }

  Future<void> removeFromWishlist(Shoe shoe, String? email) async {
    await _cartService.removeFromWishlist(shoe, email);
  }
}
