import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/core/exception.dart';
import '../../domain/core/failure.dart';
import '../../domain/core/success.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repo.dart';
import '../helpers/network.conection.dart';
import '../sources/firebase/user_collection.dart';

class UserRepoImpl implements UserRepo {
  final UserCollection _collection = UserCollection();

  @override
  Future<Either<Failure, Success<UserModel>>> createUser(UserModel model, List<String> areaOfInterest, XFile? file) async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _collection.createUser(model, areaOfInterest, file));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success<UserModel>>> getUser(String id) async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _collection.getUser(id));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success<UserModel>>> updateUser(UserModel model, XFile? file) async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _collection.updateUser(model, file));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
