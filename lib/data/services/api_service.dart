import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String baseUrl = 'https://api.katrix.com.ar';
  
  // Claves leídas desde el .env
  static String get licenseSecret => dotenv.env['KATRIX_LICENSE_SECRET'] ?? '';
  static String get secretKey => dotenv.env['KATRIX_SECRET_KEY'] ?? '';

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'x-license-secret': licenseSecret,
      'x-secret-key': secretKey,
    };
  }

  // Ejemplo de petición GET
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en GET: $e');
    }
  }

  // Ejemplo de petición POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  // Manejo de la respuesta
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      throw Exception(
        'Error de API: ${response.statusCode} - ${response.reasonPhrase}\n${response.body}'
      );
    }
  }
}

// Instancia global para ser utilizada en los providers
final apiService = ApiService();
