import 'package:NikeStore/models/shoe.dart';
import 'package:NikeStore/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UserService userService = UserService();
  List<Shoe> wishlist_shoes = [];

  List<Shoe> get wishlistShoes => wishlist_shoes;

  Future<void> fetchWishList(String email) async {
    wishlist_shoes = await userService.fetchWishList(email);
    notifyListeners();
  }

  Future<bool> checkWishList(Shoe shoe, String? email) {
    return userService.checkWishList(shoe, email);
  }

  Future<void> addToWishlist(Shoe shoe, String? email) async {
    await userService.addToWishlist(shoe, email);
    notifyListeners();
  }

  Future<void> removeFromWishlist(Shoe shoe, String? email) async {
    await userService.removeFromWishlist(shoe, email);
    notifyListeners();
  }
}
