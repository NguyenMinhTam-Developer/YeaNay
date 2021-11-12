import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.dob,
    required this.location,
    required this.state,
    required this.city,
    required this.country,
  });

  String? id;
  String? avatar;
  String? name;
  String? email;
  String? dob;
  GeoPoint? location;
  String? state;
  String? city;
  String? country;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        avatar: json["avatar"],
        name: json["name"],
        email: json["email"],
        dob: json["dob"],
        location: json["location"],
        state: json["state"],
        city: json["city"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "name": name,
        "email": email,
        "dob": dob,
        "location": location,
        "state": state,
        "city": city,
        "country": country,
      };
}
