import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  User({required this.username, required this.password});

  factory User.fromMap(Map<String, dynamic> map) => User(
        username: map['username'],
        password: map['password'],
      );

  Map<String, dynamic> toMap() => {'username': username, 'password': password};
}