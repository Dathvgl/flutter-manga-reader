import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String? email;
  final String? name;
  final String? photo;

  static const empty = UserModel(id: "");
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  const UserModel({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  factory UserModel.copyWith(User user) {
    return UserModel(
      id: user.uid,
      email: user.email,
      name: user.displayName,
      photo: user.photoURL,
    );
  }
}
