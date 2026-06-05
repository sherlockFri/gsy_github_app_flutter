import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.id,
    this.username,
    this.avatarUrl,
    this.name,
    this.email,
    this.phone,
  });

  int? id;
  String? username;
  String? avatarUrl;
  String? name;
  String? email;
  String? phone;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.empty();
}
