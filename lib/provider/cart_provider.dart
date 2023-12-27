import 'package:flutter/material.dart';

import '../models/shoe.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  List<Shoe> _userCart = [];
  double _total = 0;
  List<Shoe> get cart => _userCart;
  double get totalPrice => _total;

  Future<void> fetchCart(String email) async {
    _userCart = await _cartService.getCurrentUserCart(email);
    notifyListeners();
  }

  Future<void> addToCart(Shoe shoe, String email, int? selectedSize) async {
    await _cartService.addToFirestore(shoe, email, selectedSize);
    await fetchCart(email);
  }

  Future<void> clearCart(String email) async {
    await _cartService.clearFirestoreCart(email);
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

  Future<double> calculateTotal(String email) async {
    _total = await _cartService.calculateTotalPrice(email);
    return _total;
  }

  Future<num> getCartItemCount(String email) async {
    num itemCount = await _cartService.getCartItemCount(email);
    return itemCount;
  }
}
