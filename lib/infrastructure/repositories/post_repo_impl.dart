import 'package:dartz/dartz.dart';

import '../../domain/core/exception.dart';
import '../../domain/core/failure.dart';
import '../../domain/core/success.dart';
import '../../domain/models/post_model.dart';
import '../../domain/repositories/post_repo.dart';
import '../helpers/network.conection.dart';
import '../sources/firebase/post_collection.dart';

class PostRepoImpl implements PostRepo {
  final PostCollection _api = PostCollection();

  @override
  Future<Either<Failure, Success<PostModel>>> createPost(PostModel model) async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _api.createPost(model));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success<Either<List<PostModel>, PostModel>>>> getPost({String? id, List<String>? ids}) async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _api.getPost(id: id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
