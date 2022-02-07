// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      role: json['role'] as String? ?? '',
      disabled: json['disabled'] == null
          ? null
          : DateTime.parse(json['disabled'] as String),
      unregistered: json['unregistered'] == null
          ? null
          : DateTime.parse(json['unregistered'] as String),
      begin: json['begin'] == null
          ? null
          : DateTime.parse(json['begin'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      expire: json['expire'] == null
          ? null
          : DateTime.parse(json['expire'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'displayName': instance.displayName,
      'role': instance.role,
      'disabled': instance.disabled?.toIso8601String(),
      'unregistered': instance.unregistered?.toIso8601String(),
      'begin': instance.begin?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'expire': instance.expire?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
