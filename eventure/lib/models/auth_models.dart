// lib/models/auth_models.dart

import 'dart:convert';

// --- Backend'e Giriş İsteği Göndermek İçin Model ---
class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  // Dart objesini JSON metnine çevirir
  String toJson() => json.encode({'email': email, 'password': password});
}

// --- Backend'den Gelen Giriş Cevabını Almak İçin Model ---
class LoginResponseModel {
  final String refresh;
  final String access;

  LoginResponseModel({required this.refresh, required this.access});

  // JSON metninden Dart objesi oluşturur
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(refresh: json['refresh'], access: json['access']);
  }
}

// --- Backend'e Kayıt İsteği Göndermek İçin Model ---
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

  // Dart objesini JSON metnine çevirir
  String toJson() => json.encode({
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'password2': password2,
  });
}
