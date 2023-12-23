import 'package:flutter/material.dart';

import '../models/shoe.dart';
import '../services/shoe_service.dart';

class ShoeProvider with ChangeNotifier {
  final ShoeService _shoeService = ShoeService();
  List<Shoe> _shoes = [];
  List<Shoe> _hotPicks = [];
  List<Shoe> _filteredShoes = [];
  String _searchQuery = '';
  List<String> categoryName = [];

  List<Shoe> get hotPicks => _hotPicks;
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

  Future<void> fetchTopCategories() async {
    categoryName = await _shoeService.fetchTopCategories();

    notifyListeners();
  }

  Future<void> fetchHotPicks() async {
    _hotPicks = await _shoeService.fetchHotPicks();
    _filteredShoes = List.from(_shoes);
    notifyListeners();
  }
}
