import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/core/exception.dart';

import '../../../domain/core/success.dart';
import '../../../domain/models/user_model.dart';

class UserCollection {
  final _colection = FirebaseFirestore.instance.collection('users');

  Future<Success<UserModel>> createUser(UserModel user) async {
    try {
      return _colection.add({}).then((document) {
        user.id = document.id;

        return _colection.doc(document.id).set(user.toJson()).then((value) {
          return Success(
            message: "Sign-up success!",
            data: user,
          );
        });
      });
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  Future<Success<UserModel>> getUser(String id) async {
    try {
      return _colection.doc(id).get().then((document) {
        if (document.exists && document.data() != null) {
          return Success(
            data: UserModel.fromJson(document.data()!),
          );
        } else {
          throw ServerException(
            message: "User doesn't exist!",
          );
        }
      });
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  Future<Success<UserModel>> updateUser(UserModel user) async {
    try {
      if (user.id != null) {
        return _colection.doc(user.id).update(user.toJson()).then((value) {
          return Success(
            message: "User has been updated",
            data: user,
          );
        });
      } else {
        throw ServerException(
          message: "User doesn't exist!",
        );
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
}
