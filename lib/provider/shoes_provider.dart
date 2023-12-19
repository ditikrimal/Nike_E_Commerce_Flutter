import 'package:flutter/material.dart';
import '../models/shoe.dart';
import '../services/shoe_service.dart';

class ShoeProvider with ChangeNotifier {
  final ShoeService _shoeService = ShoeService();
  List<Shoe> _shoes = [];
  List<Shoe> _filteredShoes = [];
  String _searchQuery = '';

  List<Shoe> get shoes => _shoes;
  List<Shoe> get filteredShoes => _filteredShoes;
  String get searchQuery => _searchQuery;

  ShoeProvider() {
    fetchShoes();
  }
  set filteredShoes(List<Shoe> value) {
    _filteredShoes = value;
    notifyListeners();
  }

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<void> fetchShoes() async {
    _shoes = await _shoeService.fetchShoesFromFirestore();
    _filteredShoes = List.from(_shoes);
    notifyListeners();
  }
}
