// lib/services/event_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../models/category_model.dart'; // <<< Category modelini import ediyoruz.

class EventService {
  static String getBaseUrl() {
    // kIsWeb, web platformunda çalışıp çalışmadığını kontrol eder.
    if (kIsWeb) {
      return 'http://192.168.1.80:8000'; // Web için /api olmadan
    }
    // Platform kontrolü sadece mobil veya masaüstü için yapılır.
    if (Platform.isAndroid) {
      return 'http://192.168.1.80:8000'; // Android emülatörü için
    }
    // iOS simülatörü ve diğer platformlar için.
    return 'http://192.168.1.80:8000';
  }

  // baseApiUrl, tüm API istekleri için /api/ ön ekini içerir.
  final String baseApiUrl = '${getBaseUrl()}/api';
  final String baseMediaUrl = getBaseUrl(); // Resimler için /api olmadan

  // --- Etkinlik (Event) Metodları ---

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$baseApiUrl/events/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        // Gelen resim URL'lerine base URL'i ekleyelim.
        return data.map((json) {
          // Eğer image URL'i '/' ile başlıyorsa, base URL'i ekle.
          if (json['image'] != null && json['image'].startsWith('/')) {
            json['image'] = '$baseMediaUrl${json['image']}';
          }
          return Event.fromJson(json);
        }).toList();
      } else {
        throw Exception(
          'Failed to load events. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in fetchEvents: $e');
      rethrow; // Hatayı UI katmanına bildir.
    }
  }

  Future<List<Event>> fetchPopularEvents() async {
    // Popüler etkinlikler için doğru ve yeni endpoint'i kullanıyoruz.
    final response = await http.get(Uri.parse('$baseApiUrl/events/popular/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) {
        if (json['image'] != null && json['image'].startsWith('/')) {
          json['image'] = '$baseMediaUrl${json['image']}';
        }
        return Event.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load popular events');
    }
  }

  // --- Kategori (Category) Metodları ---

  Future<List<Category>> fetchCategories() async {
    // Kategoriler için doğru ve yeni endpoint'i kullanıyoruz.
    final response = await http.get(
      Uri.parse('$baseApiUrl/events/categories/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      // Artık Map yerine tip-güvenli Category nesneleri döndürüyoruz.
      return data.map((json) {
        if (json['image'] != null && json['image'].startsWith('/')) {
          json['image'] = '$baseMediaUrl${json['image']}';
        }
        return Category.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load categories from API');
    }
  }

  // --- Filtreleme ve Arama Metodları ---

  Future<List<Event>> fetchEventsByCategory(String categoryName) async {
    final encodedCategoryName = Uri.encodeComponent(categoryName);
    // Django backend'inizde bu filtreleme mantığını (?category=...) kurmanız gerekir.
    final response = await http.get(
      Uri.parse('$baseApiUrl/events/?category=$encodedCategoryName'),
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
      throw Exception('Failed to load events for category "$categoryName"');
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
