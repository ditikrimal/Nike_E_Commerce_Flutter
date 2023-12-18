import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthHandle {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        // User canceled the sign-in process
        return null;
      }

      // Obtain GoogleSignInAuthentication
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Create GoogleAuthCredential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      // Sign in with Google
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(authResult.user!.email)
          .set({
        'name': authResult.user!.displayName,
        'email': authResult.user!.email,
        'photoUrl': "",
        'phoneNumber': "",
        'isVerified': false,
      });

      return authResult.user;
    } catch (error) {
      print("Google Sign-In Error: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Add signOut, getCurrentUser, and other methods as needed
}
