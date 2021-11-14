import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yea_nay/presentation/screens/auth/login_screen.dart';
import 'package:yea_nay/presentation/screens/main_page.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(seconds: 3), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offNamed(MainScreen.routeName);
      } else {
        Get.offNamed(LoginScreen.routeName);
      }
    });
  }
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
