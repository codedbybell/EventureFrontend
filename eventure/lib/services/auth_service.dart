// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';

class AuthService {
  // Backend sunucunun adresini buraya yaz.
  // Android emülatörü için 10.0.2.2, iOS için localhost veya gerçek IP adresin.
  final String baseUrl = "http://192.168.1.80:8000/api";

  // --- Giriş Yapma Fonksiyonu ---
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      headers: {'Content-Type': 'application/json'},
      body: requestModel.toJson(),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      // Hata durumunda, backend'den gelen mesajı fırlat.
      throw Exception('Giriş başarısız: ${response.body}');
    }
  }

  // --- Kayıt Olma Fonksiyonu ---
  Future<bool> register(RegisterRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {'Content-Type': 'application/json'},
      body: requestModel.toJson(),
    );

    if (response.statusCode == 201) {
      // Kayıt başarılıysa true döndür.
      return true;
    } else {
      // Hata durumunda, backend'den gelen hata mesajını fırlat.
      // Örnek: {"email": ["Bu e-posta zaten kullanımda."]}
      throw Exception('Kayıt başarısız: ${response.body}');
    }
  }
}
