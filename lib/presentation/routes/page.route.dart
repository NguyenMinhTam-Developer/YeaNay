import 'package:get/get.dart';
import '../screens/main_page.dart';
import '../controllers/auth_controller.dart';
import '../screens/auth/login_screen.dart';

class RoutePage {
  static final List<GetPage> pages = [
    // Auth Screens
    GetPage(name: LoginScreen.routeName, page: () => const LoginScreen(), binding: AuthBinding()),
    GetPage(name: MainPage.routeName, page: () => const MainPage()),
  ];
}
