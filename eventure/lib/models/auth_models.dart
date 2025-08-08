// lib/models/auth_models.dart

import 'dart:convert';

// --- GİRİŞ İÇİN MODELLER ---
class LoginRequestModel {
  final String email;
  final String password;
  LoginRequestModel({required this.email, required this.password});
  String toJson() => json.encode({'email': email, 'password': password});
}

class LoginResponseModel {
  final String refresh;
  final String access;
  LoginResponseModel({required this.refresh, required this.access});
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      refresh: json['refresh'],
      access: json['access'],
    );
  }
}

// --- KAYIT OLMA İÇİN MODEL ---
class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String password2;
  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.password2,
  });
  String toJson() => json.encode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'password2': password2,
      });
}

// --- KULLANICI PROFİLİ İÇİN MODEL ---
class UserProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? bio;
  final String? profilePictureUrl;

  UserProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.bio,
    this.profilePictureUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'],
      profilePictureUrl: json['profile_picture'],
    );
  }
}

// --- ŞİFRE DEĞİŞTİRME İÇİN MODEL ---
class ChangePasswordRequestModel {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirm;

  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  String toJson() => json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirm': newPasswordConfirm,
      });
}
