import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../core/failure.dart';
import '../core/success.dart';
import '../models/user_model.dart';

abstract class UserRepo {
  Future<Either<Failure, Success<UserModel>>> createUser(UserModel model, List<String> areaOfInterest, XFile? file);

  Future<Either<Failure, Success<UserModel>>> getUser(String id);

  Future<Either<Failure, Success<UserModel>>> updateUser(UserModel model, XFile? file);
}
