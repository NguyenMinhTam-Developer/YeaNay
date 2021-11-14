import 'package:get/get.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/controllers/post_controller.dart';
import 'package:yea_nay/presentation/controllers/user_controller.dart';
import 'package:yea_nay/presentation/controllers/vote_controller.dart';

class MainController extends GetxController {
  AuthController authController = Get.put(AuthController());
  PostController postController = Get.put(PostController());
  UserController userController = Get.put(UserController());
  VoteController voteController = Get.put(VoteController());
}

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => PostController());
    Get.lazyPut(() => UserController());
    Get.lazyPut(() => VoteController());
  }
}
