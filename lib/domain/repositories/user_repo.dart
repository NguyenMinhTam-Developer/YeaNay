import 'package:dartz/dartz.dart';

import '../core/failure.dart';
import '../core/success.dart';
import '../models/user_model.dart';

abstract class UserRepo {
  Future<Either<Failure, Success<UserModel>>> createUser(UserModel model);

  Future<Either<Failure, Success<UserModel>>> getUser(String id);

  Future<Either<Failure, Success<UserModel>>> updateUser(UserModel model);
}
