// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';
import 'token_service.dart';

class AuthService {
  // Kendi IP adresini yazdığından emin ol!
  final String baseUrl = "http://192.168.1.80:8000/api";
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
      // Başarılı girişte token'ları merkezi bir yere kaydediyoruz.
      await _tokenService.saveTokens(
          loginResponse.access, loginResponse.refresh);
    } else {
      // Hata durumunda, backend'den gelen mesajı fırlatıyoruz.
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
      // Backend'den gelen spesifik hata mesajını göstermek için
      final errorBody = json.decode(response.body);
      String errorMessage = "Kayıt başarısız oldu.";
      if (errorBody is Map && errorBody.containsKey('email')) {
        errorMessage =
            errorBody['email'][0]; // Örn: "Bu e-posta zaten kullanımda."
      }
      throw Exception(errorMessage);
    }
  }

  /// Mevcut kullanıcının profil bilgilerini getirir.
  Future<UserProfileModel> getProfile() async {
    // Token'ı merkezi yerden okuyoruz.
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
      // UTF-8 decode ile Türkçe karakter sorununu çözüyoruz.
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
    // Token'ı merkezi yerden okuyoruz.
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null) {
      throw Exception('Giriş yapılmamış veya oturum süresi dolmuş.');
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("$baseUrl/profile/"),
    );

    request.headers['Authorization'] = 'Bearer $accessToken';

    // Metin alanlarını ekliyoruz.
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.fields['bio'] = bio;

    // Eğer kullanıcı yeni bir resim seçtiyse, onu da isteğe ekliyoruz.
    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture', // Bu isim Django modelindeki alan adıyla aynı olmalı!
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
    // Token'ları merkezi yerden okuyoruz.
    final accessToken = await _tokenService.getAccessToken();
    final refreshToken = await _tokenService.getRefreshToken();

    // Eğer cihazda token yoksa, zaten çıkış yapılmış demektir.
    if (accessToken == null || refreshToken == null) return;

    try {
      // Backend'e token'ı karalisteye alması için istek gönderiyoruz.
      await http.post(
        Uri.parse("$baseUrl/logout/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({'refresh': refreshToken}),
      );
    } catch (e) {
      // Backend'e ulaşılamasa veya hata verse bile devam et,
      // çünkü asıl önemli olan cihazdan token'ları silmek.
      print("Logout sırasında sunucu hatası (önemsiz olabilir): $e");
    } finally {
      // Her durumda (başarılı veya başarısız) cihazdaki token'ları siliyoruz.
      await _tokenService.deleteTokens();
    }
  }
}
