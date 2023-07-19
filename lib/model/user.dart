import 'dart:convert';

import 'package:hive/hive.dart';

part 'user.g.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

@HiveType(typeId: 4)
class User {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;

  @HiveField(3)
  String user_type;

  @HiveField(4)
  String? image;

  @HiveField(5)
  String? phone_number;

  String? latitude;
  String? longitude;

  // @HiveField(4)
  // DateTime? birthDay;

  // String? image;
  // DateTime? birthDay;

  // User({required this.id,required this.name,required this.email,this.image, this.birthDay});
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.user_type,
      required this.image,
      required this.phone_number,
      required this.latitude,
      required this.longitude,
      });

  factory User.fromJson(Map<String, dynamic> data) {
    print('user');
    return User(
      id: data['id'].toString(),
      name: data['name'],
      email: data['email'],
      user_type: data['user_type'],
      image: data['image'],
      phone_number: data['phone_number'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'email': this.email,
        'user_type': this.user_type,
        'image': this.image,
        'phone_number': this.phone_number,
        'latitude': this.latitude,
        'longitude': this.longitude,
      };
}
