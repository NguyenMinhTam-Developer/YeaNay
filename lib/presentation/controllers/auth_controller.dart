// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:yea_nay/domain/models/user_model.dart';
import 'package:yea_nay/presentation/screens/auth/login_screen.dart';

import '../layouts/event_helper.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main_page.dart';

class AuthController extends GetxController {
  var isAnonymous = false.obs;

  UserModel? currentUser;

  signInWithGoogle() async {
    print("Auth Controller - Google Sign In: Sign in with Google");
    EventHelper.openLoadingDialog();
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential credential = await FirebaseAuth.instance.signInWithCredential(authCredential);

      FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get().then((userDoc) {
        if (userDoc.exists) {
          EventHelper.closeLoadingDialog();
          Get.offAll(() => const MainScreen());
        } else {
          EventHelper.closeLoadingDialog();
          Get.to(
            () => RegisterScreen(
              avatarUrl: credential.user?.photoURL,
              displayName: credential.user?.displayName,
              email: credential.user?.email,
            ),
          );
        }
      });
    } catch (e) {
      print("Auth Controller - Google Sign In: " + e.toString());
    }
  }

  signInWithFacebook() async {
    EventHelper.openLoadingDialog();
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential credential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get().then((userDoc) {
        if (userDoc.exists) {
          EventHelper.closeLoadingDialog();
          Get.offAll(() => const MainScreen());
        } else {
          EventHelper.closeLoadingDialog();
          Get.to(
            () => RegisterScreen(
              avatarUrl: credential.user?.photoURL,
              displayName: credential.user?.displayName,
              email: credential.user?.email,
            ),
          );
        }
      });
    } catch (e) {
      print("Auth Controller - Facebook Sign In: " + e.toString());
    }
  }

  signInWithTwitter() async {
    EventHelper.openLoadingDialog();
    try {
      // Create a TwitterLogin instance
      final twitterLogin = TwitterLogin(apiKey: '<your consumer key>', apiSecretKey: ' <your consumer secret>', redirectURI: '<your_scheme>://');

      // Trigger the sign-in flow
      final authResult = await twitterLogin.login();

      // Create a credential from the access token
      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      // Once signed in, return the UserCredential
      UserCredential credential = await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

      FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get().then((userDoc) {
        if (userDoc.exists) {
          EventHelper.closeLoadingDialog();
          Get.offAll(() => const MainScreen());
        } else {
          EventHelper.closeLoadingDialog();
          Get.to(
            () => RegisterScreen(
              avatarUrl: credential.user?.photoURL,
              displayName: credential.user?.displayName,
              email: credential.user?.email,
            ),
          );
        }
      });
    } catch (e) {
      print("Auth Controller - Twitter Sign In: " + e.toString());
    }
  }

  signInWithApple() async {
    //
  }

  signInAnonymously() async {
    try {
      EventHelper.openLoadingDialog();
      FirebaseAuth.instance.signInAnonymously().then((value) {
        EventHelper.closeLoadingDialog();
        Get.offAllNamed(MainScreen.routeName);
      });
    } catch (e) {
      EventHelper.closeLoadingDialog();
      EventHelper.openSnackBar(
        title: "Failed",
        message: "Failed to login in with guest",
        type: AlertType.danger,
      );
    }
  }

  signOut() async {
    FirebaseAuth.instance.signOut().then(
          (value) => Get.offAllNamed(LoginScreen.routeName),
        );
  }

  Future<void> createProfile({
    required String displayName,
    required String dateOfBirth,
    required String email,
    required String city,
    required String state,
    required String country,
    required List<String> topics,
    String? avatarUrl,
    XFile? selectedImage,
  }) async {
    print("Auth Controller - Create Profile: Creating new profile");

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    GeoPoint userLocation = GeoPoint(position.latitude, position.longitude);

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        FirebaseFirestore.instance.collection('users').add({}).then((doc) async {
          if (selectedImage != null) {
            File file = File(selectedImage.path);

            try {
              print("Auth Controller - Create Profile: Upload selected avatar file");

              await FirebaseStorage.instance.ref('users/${doc.id}-avatar.png').putFile(file).then((p0) async {
                print("Auth Controller - Create Profile: Getting uploaded avatar Url");

                await FirebaseStorage.instance.ref('users/${doc.id}-avatar.png').getDownloadURL().then((downloadURL) {
                  print("Auth Controller - Create Profile: Create new user on Firestore");

                  FirebaseFirestore.instance.collection('users').doc(doc.id).set({
                    "profile_image": downloadURL,
                    "name": displayName,
                    "dob": dateOfBirth,
                    "email": email,
                    "city": city,
                    "state": state,
                    "country": country,
                    "area_of_interest": topics,
                    "location": userLocation,
                  }).then((value) => Get.to(() => const MainScreen()));
                });
              });
            } on FirebaseException catch (e) {
              print("Auth Controller - Create Profile: Failed to get uploaded avatar Url - ${e.toString()}");
            }
          } else {
            print("Auth Controller - Create Profile: Create new user on Firestore");

            FirebaseFirestore.instance.collection('users').doc(doc.id).set({
              "profile_image": avatarUrl,
              "name": displayName,
              "dob": dateOfBirth,
              "email": email,
              "city": city,
              "state": state,
              "country": country,
              "area_of_interest": topics,
              "location": userLocation,
            }).then((value) => Get.offAll(() => const MainScreen()));
          }
        });
      } else {
        if (selectedImage != null) {
          File file = File(selectedImage.path);

          try {
            print("Auth Controller - Create Profile: Upload selected avatar file");

            await FirebaseStorage.instance.ref('users/${user.uid}-avatar.png').putFile(file).then((p0) async {
              print("Auth Controller - Create Profile: Getting uploaded avatar Url");

              await FirebaseStorage.instance.ref('users/${user.uid}-avatar.png').getDownloadURL().then((downloadURL) {
                print("Auth Controller - Create Profile: Create new user on Firestore");

                FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                  "profile_image": downloadURL,
                  "name": displayName,
                  "dob": dateOfBirth,
                  "email": email,
                  "city": city,
                  "state": state,
                  "country": country,
                  "area_of_interest": topics,
                  "location": userLocation,
                }).then((value) => Get.offAll(() => const MainScreen()));
              });
            });
          } on FirebaseException catch (e) {
            print("Auth Controller - Create Profile: Failed to get uploaded avatar Url - ${e.toString()}");
          }
        } else {
          print("Auth Controller - Create Profile: Create new user on Firestore");

          FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            "profile_image": avatarUrl,
            "name": displayName,
            "dob": dateOfBirth,
            "email": email,
            "city": city,
            "state": state,
            "country": country,
            "area_of_interest": topics,
            "location": userLocation,
          }).then((value) => Get.offAll(() => const MainScreen()));
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();

    isAnonymous.value = FirebaseAuth.instance.currentUser?.isAnonymous ?? true;

    if (!isAnonymous.value) {
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get().then((userDoc) {
        currentUser = UserModel.fromJson(userDoc.data()!);
      });
    }

    print("User is Anonymous: ${isAnonymous.value}");
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
