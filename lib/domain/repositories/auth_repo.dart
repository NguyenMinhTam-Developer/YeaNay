import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yea_nay/domain/core/failure.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserCredential>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();
}
