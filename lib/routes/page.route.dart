import 'package:get/get.dart';
import 'package:yea_nay/controllers/auth_controller.dart';
import 'package:yea_nay/view/login/screens/login_page.dart';

class RoutePage {
  static final List<GetPage> pages = [
    // Auth Screens
    GetPage(name: LoginPage.routeName, page: () => const LoginPage(), binding: AuthBinding()),
  ];
}
