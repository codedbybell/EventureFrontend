// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';
import 'token_service.dart';

class AuthService {
  // Kendi IP adresini yazdığından emin ol!
  final String baseUrl = "http://192.168.1.86:8000/api/users";
  final TokenService _tokenService = TokenService();

  /// Kullanıcı girişi yapar ve başarılı olursa token'ları kaydeder.
  Future<void> login(LoginRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      headers: {'Content-Type': 'application/json'},
      body: requestModel.toJson(),
    );

    if (response.statusCode == 200) {
      final loginResponse =
          LoginResponseModel.fromJson(json.decode(response.body));
      await _tokenService.saveTokens(
          loginResponse.access, loginResponse.refresh);
    } else {
      final errorBody = json.decode(response.body);
      throw Exception(errorBody['detail'] ?? 'Giriş başarısız oldu.');
    }
  }

  /// Yeni kullanıcı kaydı oluşturur.
  Future<bool> register(RegisterRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {'Content-Type': 'application/json'},
      body: requestModel.toJson(),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      final errorBody = json.decode(response.body);
      String errorMessage = "Kayıt başarısız oldu.";
      if (errorBody is Map && errorBody.containsKey('email')) {
        errorMessage = errorBody['email'][0];
      }
      throw Exception(errorMessage);
    }
  }

  /// Mevcut kullanıcının profil bilgilerini getirir.
  Future<UserProfileModel> getProfile() async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Giriş yapılmamış veya oturum süresi dolmuş.');
    }

    final response = await http.get(
      Uri.parse("$baseUrl/profile/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Profil bilgileri alınamadı.');
    }
  }

  /// Kullanıcının profil bilgilerini (metin ve resim) günceller.
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String bio,
    File? profileImage,
  }) async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Giriş yapılmamış veya oturum süresi dolmuş.');
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("$baseUrl/profile/"),
    );

    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.fields['bio'] = bio;

    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          profileImage.path,
        ),
      );
    }

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      return true;
    } else {
      final responseBody = await streamedResponse.stream.bytesToString();
      print("Profil güncelleme hatası: $responseBody");
      throw Exception('Profil güncellenemedi.');
    }
  }

  /// Kullanıcı çıkışı yapar ve hem backend'de hem de cihazda token'ları geçersiz kılar.
  Future<void> logout() async {
    final accessToken = await _tokenService.getAccessToken();
    final refreshToken = await _tokenService.getRefreshToken();

    if (accessToken == null || refreshToken == null) return;

    try {
      await http.post(
        Uri.parse("$baseUrl/logout/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'refresh': refreshToken}),
      );
    } catch (e) {
      print("Logout sırasında sunucu hatası (önemsiz olabilir): $e");
    } finally {
      await _tokenService.deleteTokens();
    }
  }

  /// Oturum açmış kullanıcının şifresini değiştirir.
  Future<bool> changePassword(ChangePasswordRequestModel requestModel) async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Lütfen önce giriş yapın.');
    }

    final response = await http.put(
      Uri.parse("$baseUrl/change-password/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: requestModel.toJson(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final errorBody = json.decode(utf8.decode(response.bodyBytes));
      String errorMessage = "Şifre değiştirilemedi.";
      if (errorBody is Map) {
        if (errorBody.containsKey('old_password')) {
          errorMessage = errorBody['old_password'][0];
        } else if (errorBody.containsKey('new_password')) {
          errorMessage = errorBody['new_password'][0];
        } else if (errorBody.containsKey('detail')) {
          errorMessage = errorBody['detail'];
        } else {
          // Genel bir hata mesajı için tüm hataları birleştirelim
          errorMessage = errorBody.values.map((e) => e.toString()).join(' ');
        }
      }
      throw Exception(errorMessage);
    }
  }
}
