import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  // id
  String id;

  // name
  String username;
  String displayName;

  // role and flags
  String role;
  DateTime? disabled;
  DateTime? unregistered;

  // when login
  DateTime? begin;
  DateTime? end;
  DateTime? expire;

  // created
  DateTime? createdAt;
  // updated
  DateTime? updatedAt;

  // constructor
  User({
    this.id = '',
    this.username = '',
    this.displayName = '',
    this.role = '',
    this.disabled,
    this.unregistered,
    this.begin,
    this.end,
    this.expire,
    this.createdAt,
    this.updatedAt,
  });

  // from and to JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() =>
      '$id, name=$username, display=$displayName, role=$role, disabled=$disabled, unregistered=$unregistered';
}
