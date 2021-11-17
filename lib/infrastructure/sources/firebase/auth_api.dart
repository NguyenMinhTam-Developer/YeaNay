import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yea_nay/domain/core/exception.dart';

class AuthApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return _firebaseAuth.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.code);
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
