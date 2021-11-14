import 'package:get/get.dart';
import 'package:yea_nay/presentation/controllers/main_controller.dart';
import 'package:yea_nay/presentation/controllers/splash_controller.dart';
import 'package:yea_nay/presentation/screens/create_post_screen.dart';
import 'package:yea_nay/presentation/screens/splash/splash_screen.dart';
import '../screens/main_page.dart';
import '../controllers/auth_controller.dart';
import '../screens/auth/login_screen.dart';

class RoutePage {
  static final List<GetPage> pages = [
    // Splash Screen
    GetPage(name: SplashScreen.routeName, page: () => const SplashScreen(), binding: SplashBinding()),

    // Auth Screens
    GetPage(name: LoginScreen.routeName, page: () => const LoginScreen(), binding: AuthBinding()),
    GetPage(name: MainScreen.routeName, page: () => const MainScreen(), binding: MainBinding()),

    GetPage(name: CreatePostScreen.routeName, page: () => const CreatePostScreen()),
  ];
}
