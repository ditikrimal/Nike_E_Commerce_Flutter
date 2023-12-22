class Shoe {
  final String shoeID;
  final String name;
  final double price;
  final String imagePath;
  final String description;
  final String category;
  final int numberOfItems;
  final int pickedTime;
  Shoe({
    required this.shoeID,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.category,
    this.numberOfItems = 1,
    this.pickedTime = 0,
  });
}
