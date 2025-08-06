import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String baseUrl;
  final String apiKey;

  ApiService({this.baseUrl = 'https://tu-api.com/v1', this.apiKey = ''});

  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error en GET $endpoint: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error en POST $endpoint: $e');
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error en PUT $endpoint: $e');
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error en DELETE $endpoint: $e');
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not Found: ${response.body}');
      case 500:
        throw Exception('Server Error: ${response.body}');
      default:
        throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
} 