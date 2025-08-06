import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String baseUrl;
  final String apiKey;
  final String jwtToken; // Para autenticación JWT

  ApiService({
    required this.baseUrl,
    this.apiKey = '',
    this.jwtToken = '',
  });

  // Método para actualizar el token JWT
  void updateToken(String newToken) {
    jwtToken = newToken;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final headers = {
        'Content-Type': 'application/json',
        if (apiKey.isNotEmpty) 'Authorization': 'ApiKey $apiKey',
        if (jwtToken.isNotEmpty) 'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(uri, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error en GET $endpoint: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        if (apiKey.isNotEmpty) 'Authorization': 'ApiKey $apiKey',
        if (jwtToken.isNotEmpty) 'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Error en POST $endpoint: $e');
      rethrow;
    }
  }

  // ... (put, delete methods similar to post)

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // OK
      case 201: // Created
        return jsonDecode(response.body);
      case 204: // No Content
        return null;
      case 400: // Bad Request
        throw BadRequestException(response.body.toString());
      case 401: // Unauthorized
        throw UnauthorizedException(response.body.toString());
      case 403: // Forbidden
        throw ForbiddenException(response.body.toString());
      case 404: // Not Found
        throw NotFoundException(response.body.toString());
      case 500: // Server Error
        throw ServerException(response.body.toString());
      default:
        throw FetchDataException(
          'Error occurred while communicating with server. StatusCode: ${response.statusCode}',
        );
    }
  }
}

// Excepciones personalizadas
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

// ... otras excepciones similares