import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_e_commerce/services/auth/auth_user.dart';

Future<bool> checkEmail(email) async {
  // Check if the email is verified or not
  var collection = FirebaseFirestore.instance.collection('UserInfo');
  var docSnapshot = await collection
      .doc(
        email,
      )
      .get();

  Map<String, dynamic> data = docSnapshot.data()!;

  final isVerified = data['isVerified'];
  if (isVerified == true) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateEmailVerification(email) async {
  // Check if the email is verified or not

  Map<String, bool> dataToUpdate = {'isVerified': true};
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('UserInfo');
  collectionRef.doc(email).update(dataToUpdate);
  return true;
}
