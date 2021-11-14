import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../domain/core/alert.dart';
import '../../domain/core/failure.dart';
import '../../domain/core/success.dart';
import '../../domain/models/post_model.dart';
import '../../infrastructure/repositories/post_repo_impl.dart';
import '../helpers/event_helper.dart';

class PostController extends GetxController {
  final PostRepoImpl _repo = PostRepoImpl();

  final isLoading = false.obs;

  List<PostModel> postList = [];
  List<PostModel> userVotedPost = [];

  Future<PostModel?> createPost(PostModel post) async {
    EventHelper.openLoadingDialog();
    Either<Failure, Success<PostModel>> result = await _repo.createPost(post);
    EventHelper.closeLoadingDialog();

    return result.fold((failure) {
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (success) {
      EventHelper.openSnackBar(title: success.title, message: success.message, type: AlertType.success);
      postList.add(success.data);
      update();

      return success.data;
    });
  }

  Future<PostModel?> getPost({String? id, List<String>? ids}) async {
    if (id == null) {
      isLoading.value = true;
    } else {
      EventHelper.openLoadingDialog();
    }

    Either<Failure, Success<Either<List<PostModel>, PostModel>>> result = await _repo.getPost(id: id, ids: ids);

    if (id == null) {
      isLoading.value = false;
    } else {
      EventHelper.closeLoadingDialog();
    }

    return result.fold((failure) {
      EventHelper.openSnackBar(title: failure.title, message: failure.message, type: failure.type);
    }, (success) {
      Either<List<PostModel>, PostModel> result = success.data;

      result.fold((postList) {
        if (ids != null) {
          userVotedPost = postList;
        } else {
          this.postList = postList;
        }

        update();
      }, (post) {
        return post;
      });
    });
  }

  Future<List<PostModel>> getUserPostList() async {
    return FirebaseFirestore.instance.collection('posts').where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get().then((postDocList) {
      List<PostModel> postList = [];

      for (var post in postDocList.docs) {
        postList.add(PostModel.fromJson(post.data()));
      }

      return postList;
    });
  }

  @override
  void onInit() {
    super.onInit();
    getPost();
  }
}

class PostBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PostController());
  }
}
