import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  login() async {
    googleSignInAccount = await _googleSignIn.signIn();
    notifyListeners();
  }

  logout() async {
    googleSignInAccount = await _googleSignIn.signOut();
    notifyListeners();
  }
}
