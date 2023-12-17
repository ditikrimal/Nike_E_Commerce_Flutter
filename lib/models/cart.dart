import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_e_commerce/models/shoe.dart';

List<Shoe> userCart = [];

void addToCart(Shoe shoe) {
  userCart.add(shoe);
}

void removeFromCart(Shoe shoe) {
  userCart.remove(shoe);
}

void clearCart() {
  userCart.clear();
}

//Add to firstore inside the UersCollection
Future<void> addToFirestore(Shoe shoe) async {
  FirebaseFirestore.instance
      .collection('UsersCollection')
      .doc('user1')
      .collection('Cart')
      .add({
    userCart.toString(): {
      'name': shoe.name,
      'price': shoe.price,
      'imagePath': shoe.imagePath,
      'description': shoe.description,
    }
  });
}
