import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? role;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'is_complete')
  final bool isComplete;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.avatarUrl,
    this.isComplete = false,
  });

  bool get isOwner => role == 'owner';
  bool get isRenter => role == 'renter';

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, email, name, phone, role, avatarUrl, isComplete];
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final int? registrationStep;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.registrationStep,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      registrationStep: json['registration_step'] as int?,
    );
  }
}
