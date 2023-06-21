import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class FireAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authState {
    return _auth.authStateChanges();
  }

  User? getCurrentUser() {
    User? res = _auth.currentUser;
    return res;
  }

  Future logOut() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? adminInfo = prefs.getStringList('admin');
    if (adminInfo != null) {
      prefs.remove('admin');
    } else {
      try {
        await _googleSignIn.signOut();
        await _auth.signOut();
        print("logout sucessfully");
      } catch (err) {
        print("Error in signing-out : $err");
      }
    }
  }
}
