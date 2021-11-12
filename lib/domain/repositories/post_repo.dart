import 'package:dartz/dartz.dart';

import '../core/failure.dart';
import '../core/success.dart';
import '../models/post_model.dart';

abstract class PostRepo {
  Future<Either<Failure, Success<PostModel>>> createPost(PostModel model);

  Future<Either<Failure, Success<Either<List<PostModel>, PostModel>>>> getPost({String? id, List<String>? ids});
}
