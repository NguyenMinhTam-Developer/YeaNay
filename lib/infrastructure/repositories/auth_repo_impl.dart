import 'package:yea_nay/domain/core/exception.dart';
import 'package:yea_nay/domain/core/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:yea_nay/domain/repositories/auth_repo.dart';
import 'package:yea_nay/infrastructure/helpers/network.conection.dart';
import 'package:yea_nay/infrastructure/sources/firebase/auth_api.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthApi _authApi = AuthApi();

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _authApi.signInWithGoogle());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await NetworkConnection.isConnected) {
      try {
        return Right(await _authApi.signOut());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
