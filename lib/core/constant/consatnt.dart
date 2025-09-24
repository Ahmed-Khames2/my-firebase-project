import 'dart:ui';

const String a = "myfirebaseapp-6f58d";
const kPrimaryColor = Color(0xff2B475E);
const kLogo = 'assets/images/scholar.png';
const kMessagesCollections = 'messages';
const kMessage = 'message';
const kCreatedAt = 'createdAt';

// lib/core/constants/categories.dart
class Categories {
  static const List<String> all = [
    "All",
    "Electronics",
    "Clothes",
    "Shoes",
    "Accessories",
  ];
}


/**
 * 
 * Platform  Firebase App Id
web       1:561025241791:web:3f402e1d4b6b735e6f2c0a
android   1:561025241791:android:68d0d1416873a9376f2c0a
ios       1:561025241791:ios:3dc917ff72d175826f2c0a
macos     1:561025241791:ios:3dc917ff72d175826f2c0a
windows   1:561025241791:web:76160330b1a2fec06f2c0a
 */

 // ---- Updated Google Sign-In Function for version 7.2.0 ----
  // Future<User?> signInWithGoogle() async {
  //   try {
  //     // Use the singleton instance as per documentation
  //     final GoogleSignIn googleSignIn = GoogleSignIn.instance.authenticate() as GoogleSignIn;

  //     // Start the sign-in flow
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();//error

  //     if (googleUser == null) {
  //       // User cancelled the sign-in
  //       return null;
  //     }

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,//error
  //       idToken: googleAuth.idToken,
  //     );

  //     // Once signed in, return the UserCredential
  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     return userCredential.user;
  //   } catch (error) {
  //     print("Google Sign-In Error: $error");
  //     return null;
  //   }
  // }






//   DocumentSnapshot userDoc = await FirebaseFirestore.instance
//     .collection('users')
//     .doc(FirebaseAuth.instance.currentUser!.uid)
//     .get();

// String name = userDoc['name'];
// String imageUrl = userDoc['profileImageUrl'];
