import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/core/exception.dart';

import '../../../domain/core/success.dart';
import '../../../domain/models/user_model.dart';

class UserCollection {
  final _colection = FirebaseFirestore.instance.collection('users');

  Future<Success<UserModel>> createUser(UserModel user, List<String> areaOfInterest, XFile? file) async {
    try {
      if (file != null) {
        File _file = File(file.path);

        return await FirebaseStorage.instance.ref('users/${user.id}-avatar.png').putFile(_file).then((p0) async {
          return await FirebaseStorage.instance.ref('users/${user.id}-avatar.png').getDownloadURL().then((downloadURL) {
            user.avatar = downloadURL;
            return _colection.doc(user.id).set(user.toJson()).then((value) {
              return Success(
                message: "Sign-up success!",
                data: user,
              );
            });
          });
        });
      } else {
        return _colection.doc(user.id).set(user.toJson()).then((value) {
          return Success(
            message: "Sign-up success!",
            data: user,
          );
        });
      }
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

  Future<Success<UserModel>> updateUser(UserModel user, XFile? file) async {
    try {
      if (file != null) {
        File _file = File(file.path);

        if (user.id != null) {
          return await FirebaseStorage.instance.ref('users/${user.id}-avatar.png').putFile(_file).then((p0) async {
            return await FirebaseStorage.instance.ref('users/${user.id}-avatar.png').getDownloadURL().then((downloadURL) {
              user.avatar = downloadURL;

              return _colection.doc(user.id).update(user.toJson()).then((value) {
                return Success(
                  message: "User has been updated",
                  data: user,
                );
              });
            });
          });
        } else {
          throw ServerException(
            message: "User doesn't exist!",
          );
        }
      } else {
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
      }
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
}
