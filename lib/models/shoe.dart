class Shoe {
  final String id; // Document ID from Firestore
  final String name;
  final String category;
  final String description;
  final String imagePath;
  final int numberOfItems;
  final int pickedItems;
  final double price;
  final Map<String, int> sizes; // Map to store size information
  final int selectedSize;

  Shoe({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.numberOfItems,
    this.pickedItems = 0,
    required this.price,
    required this.sizes,
    this.selectedSize = 40,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    // Convert the Firestore data to Dart object
    Map<String, int> sizes = Map<String, int>.from(json['sizes']);
    return Shoe(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      imagePath: json['imagePath'],
      numberOfItems: json['numberOfItems'],
      pickedItems: json['pickedItems'],
      price: json['price'].toDouble(),
      sizes: sizes,
      selectedSize: json['selectedSize'],
    );
  }
}
