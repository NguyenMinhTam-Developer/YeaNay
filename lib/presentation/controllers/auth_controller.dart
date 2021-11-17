import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yea_nay/domain/core/alert.dart';
import 'package:yea_nay/domain/core/failure.dart';
import 'package:yea_nay/domain/core/success.dart';
import 'package:yea_nay/domain/models/user_model.dart';
import 'package:yea_nay/infrastructure/repositories/auth_repo_impl.dart';
import 'package:yea_nay/infrastructure/repositories/user_repo_impl.dart';
import 'package:yea_nay/presentation/helpers/event_helper.dart';
import 'package:yea_nay/presentation/screens/auth/login_screen.dart';

import '../screens/auth/register_screen.dart';
import '../screens/main_screen.dart';

class AuthController extends GetxController {
  var isAnonymous = false.obs;

  final AuthRepoImpl _authRepoImpl = AuthRepoImpl();
  final UserRepoImpl _userRepoImpl = UserRepoImpl();

  UserModel? currentUser;

  signInWithGoogle() async {
    EventHelper.openLoadingDialog();
    Either<Failure, UserCredential> result = await _authRepoImpl.signInWithGoogle();

    result.fold((failure) {
      EventHelper.closeLoadingDialog();
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (userCredential) async {
      Either<Failure, Success<UserModel>> result = await _userRepoImpl.getUser(userCredential.user?.uid ?? '');
      EventHelper.closeLoadingDialog();

      result.fold((failure) {
        Get.to(
          () => RegisterScreen(
            user: UserModel(
              id: userCredential.user?.uid,
              avatar: userCredential.user?.photoURL,
              name: userCredential.user?.displayName,
              email: userCredential.user?.email,
              dob: null,
              location: null,
              state: null,
              city: null,
              country: null,
              areaOfInterest: [],
            ),
          ),
        );
      }, (success) {
        Get.offAll(
          () => const MainScreen(),
        );
      });
    });
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
    EventHelper.openLoadingDialog();
    Either<Failure, void> result = await _authRepoImpl.signOut();
    EventHelper.closeLoadingDialog();

    result.fold((failure) {
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (success) async {
      Get.offAllNamed(LoginScreen.routeName);
    });
  }

  Future<void> createProfile(UserModel user, List<String> areaOfInterest, XFile? file) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    GeoPoint userLocation = GeoPoint(position.latitude, position.longitude);

    user.location = userLocation;
    user.areaOfInterest = areaOfInterest;

    EventHelper.openLoadingDialog();
    Either<Failure, Success<UserModel>> result = await _userRepoImpl.createUser(user, areaOfInterest, file);
    EventHelper.closeLoadingDialog();

    result.fold((failure) {
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (success) {
      EventHelper.openSnackBar(title: success.title, message: success.message, type: AlertType.success);
      Get.offAllNamed(MainScreen.routeName);
      return success.data;
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    if (FirebaseAuth.instance.currentUser != null) {
      isAnonymous.value = FirebaseAuth.instance.currentUser!.isAnonymous;

      if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
        EventHelper.openLoadingDialog();
        Either<Failure, Success<UserModel>> result = await _userRepoImpl.getUser(FirebaseAuth.instance.currentUser!.uid);
        EventHelper.closeLoadingDialog();

        result.fold(
          (failure) => EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type),
          (success) {
            currentUser = success.data;
            update();
          },
        );
      }
    }
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
