import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/core/exception.dart';
import '../../../domain/models/post_model.dart';

import '../../../domain/core/success.dart';

class PostCollection {
  final _colection = FirebaseFirestore.instance.collection('posts');

  Future<Success<PostModel>> createPost(PostModel post) async {
    try {
      return _colection.add({}).then((document) {
        post.id = document.id;

        return _colection.doc(document.id).set(post.toJson()).then((value) {
          return Success(
            message: "Sign-up success!",
            data: post,
          );
        });
      });
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  Future<Success<Either<List<PostModel>, PostModel>>> getPost({String? id, List<String>? ids}) async {
    try {
      if (id != null) {
        return _colection.doc(id).get().then((document) {
          if (document.exists && document.data() != null) {
            return Success(
              data: Right(PostModel.fromJson(document.data()!)),
            );
          } else {
            throw ServerException(
              message: "Post doesn't exist!",
            );
          }
        });
      } else if (ids != null && ids.isNotEmpty) {
        return _colection.where('id', whereIn: ids).get().then((postDocumentList) {
          List<PostModel> postList = [];

          for (var post in postDocumentList.docs) {
            postList.add(PostModel.fromJson(post.data()));
          }

          return Success(
            data: Left(postList),
          );
        });
      } else {
        return _colection.get().then((postDocumentList) {
          List<PostModel> postList = [];

          for (var post in postDocumentList.docs) {
            postList.add(PostModel.fromJson(post.data()));
          }

          print("Got ${postList.length}");

          return Success(
            data: Left(postList),
          );
        });
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
}
