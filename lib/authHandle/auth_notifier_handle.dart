import 'package:NikeStore/authHandle/email_handle.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthStatus {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get user => _auth.currentUser;

  // Get current user email
  String? get userEmail => _auth.currentUser!.email;

  // Get current user email verification status from firestore under UserInfo collection
  Future<bool> get isEmailVerified async {
    final user = _auth.currentUser;
    if (user != null) {
      final isEmailVerified = await checkEmail(user.email);
      return isEmailVerified;
    }
    return false;
  }
}
