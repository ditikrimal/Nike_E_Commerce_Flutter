class Cart {
  final String shoeID;
  final String name;
  final String price;
  final String imagePath;
  final String description;
  final int numberOfItems;
  Cart({
    required this.shoeID,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    this.numberOfItems = 1,
  });
}
