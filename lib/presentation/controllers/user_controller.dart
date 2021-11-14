import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../domain/core/alert.dart';
import '../../domain/core/failure.dart';
import '../../domain/core/success.dart';
import '../../domain/models/user_model.dart';
import '../../infrastructure/repositories/user_repo_impl.dart';
import '../helpers/event_helper.dart';

class UserController extends GetxController {
  final UserRepoImpl _repo = UserRepoImpl();

  final isLoading = false.obs;

  Future<UserModel?> createUser(UserModel user) async {
    EventHelper.openLoadingDialog();
    Either<Failure, Success<UserModel>> result = await _repo.createUser(user);
    EventHelper.closeLoadingDialog();

    return result.fold((failure) {
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (success) {
      EventHelper.openSnackBar(title: success.title, message: success.message, type: AlertType.success);
      update();

      return success.data;
    });
  }

  Future<UserModel?> getUser(String id) async {
    Either<Failure, Success<UserModel>> result = await _repo.getUser(id);

    return result.fold(
      (failure) => null,
      (success) {
        return success.data;
      },
    );
  }

  Future<UserModel?> updateUser(UserModel user) async {
    EventHelper.openLoadingDialog();
    Either<Failure, Success<UserModel>> result = await _repo.updateUser(user);
    EventHelper.closeLoadingDialog();

    return result.fold((failure) {
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (success) {
      EventHelper.openSnackBar(title: success.title, message: success.message, type: AlertType.success);

      return success.data;
    });
  }
}

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}
