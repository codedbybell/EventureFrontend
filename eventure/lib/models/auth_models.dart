// lib/models/auth_models.dart (TAM VE SON HALİ)

import 'dart:convert';

// --- Login Modelleri (Aynı Kalıyor) ---
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

// --- Register Modeli (Aynı Kalıyor) ---
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

// --- YENİ EKLENDİ: Kullanıcı Profil Modeli ---
class UserProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? bio; // Bio boş olabilir
  final String? profilePictureUrl; // Profil resmi URL'i boş olabilir

  UserProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.bio,
    this.profilePictureUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      // Django'daki first_name ve last_name'i birleştiriyoruz
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'],
      profilePictureUrl: json['profile_picture'],
    );
  }
}
