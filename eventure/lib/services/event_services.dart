import 'dart:convert';
import 'package:eventure/services/token_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/category_model.dart';

class EventService {
  // --- Sabitler ve Kurulum ---
  static String getBaseUrl() {
    // Bu fonksiyon doğru, olduğu gibi kalabilir.
    if (kIsWeb) return 'http://192.168.1.86:8000';
    if (Platform.isAndroid) return 'http://192.168.1.86:8000';
    return 'http://192.168.1.86:8000';
  }

  final TokenService _tokenService = TokenService();
  final String baseApiUrl = '${getBaseUrl()}/api';
  final String baseMediaUrl = getBaseUrl();

  // --- Yardımcı Metodlar (Kod Tekrarını Önlemek İçin) ---

  // Tek bir Event JSON'unu işleyip Event nesnesine dönüştürür.
  Event _parseSingleEvent(Map<String, dynamic> json) {
    if (json['image'] != null && json['image'].startsWith('/')) {
      json['image'] = '$baseMediaUrl${json['image']}';
    }
    return Event.fromJson(json);
  }

  // Tek bir Category JSON'unu işleyip Category nesnesine dönüştürür.
  Category _parseSingleCategory(Map<String, dynamic> json) {
    if (json['image'] != null && json['image'].startsWith('/')) {
      json['image'] = '$baseMediaUrl${json['image']}';
    }
    return Category.fromJson(json);
  }

  // Token gerektiren istekler için header'ları oluşturan yardımcı metod.
  Future<Map<String, String>> _getAuthHeaders() async {
    final String? accessToken = await _tokenService.getAccessToken();
    if (accessToken == null) {
      throw Exception('User is not authenticated. Please log in.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  // --- API Metodları ---

  // GÜNCELLENDİ: Hem book hem unbook güncel Event nesnesi döndürüyor.
  Future<Event> bookEvent(int eventId) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseApiUrl/events/$eventId/book/'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return _parseSingleEvent(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // Hata yönetimi
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['detail'] ?? 'Failed to book event.');
    }
  }

  Future<Event> unbookEvent(int eventId) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse('$baseApiUrl/events/$eventId/unbook/'),
      headers: headers,
    );

    // NOT: Backend'deki UnBookEventView'ın da güncel Event nesnesini döndürmesi gerekir.
    if (response.statusCode == 200 || response.statusCode == 201) {
      return _parseSingleEvent(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception(errorResponse['detail'] ?? 'Failed to cancel booking.');
    }
  }

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseApiUrl/events/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => _parseSingleEvent(json)).toList();
    } else {
      throw Exception('Failed to load events.');
    }
  }

  Future<List<Event>> fetchPopularEvents() async {
    final response = await http.get(Uri.parse('$baseApiUrl/events/popular/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => _parseSingleEvent(json)).toList();
    } else {
      throw Exception('Failed to load popular events');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$baseApiUrl/events/categories/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => _parseSingleCategory(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Event>> fetchEventsByCategory(String categoryName) async {
    final encodedCategoryName = Uri.encodeComponent(categoryName);
    final response = await http
        .get(Uri.parse('$baseApiUrl/events/?category=$encodedCategoryName'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => _parseSingleEvent(json)).toList();
    } else {
      throw Exception('Failed to load events for category "$categoryName"');
    }
  }

  Future<Event> fetchEventById(int eventId) async {
    final headers =
        await _getAuthHeaders(); // Detayları da token ile çekelim ki 'is_booked' doğru gelsin.
    final response = await http.get(
      Uri.parse('$baseApiUrl/events/$eventId/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return _parseSingleEvent(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load event details.');
    }
  }

  Future<List<Event>> searchEvents(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    // Django backend'inizde bu arama mantığını (?search=...) kurmanız gerekir.
    final response = await http.get(
      Uri.parse('$baseApiUrl/events/?search=$encodedQuery'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) {
        if (json['image'] != null && json['image'].startsWith('/')) {
          json['image'] = '$baseMediaUrl${json['image']}';
        }
        return Event.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to search events for query "$query"');
    }
  }
}
