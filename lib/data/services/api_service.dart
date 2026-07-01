import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String baseUrl = dotenv.env['API_URL'] ?? 'https://api.katrix.com.ar';

  // Timeout estándar para todas las peticiones
  static const Duration _timeout = Duration(seconds: 15);

  // Obtiene el token guardado
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Genera los headers con el token JWT si existe
  Future<Map<String, String>> getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Login para obtener el token JWT
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'username': username, 'password': password}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token'] ?? '');
        await prefs.setString('username', data['username'] ?? username);
        await prefs.setString('role', data['role'] ?? 'agente');
        await prefs.setInt('user_id', data['user_id'] ?? 0);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Error en Login: $e');
    }
  }

  // Cierra la sesión y limpia todos los datos locales
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('username');
    await prefs.remove('role');
    await prefs.remove('user_id');
  }

  // Recuperar contraseña enviando un link al correo
  Future<bool> recuperarPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email}),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al solicitar recuperación de contraseña: $e');
    }
  }

  // Método para crear un usuario (requiere token de Admin)
  Future<bool> crearUsuario(String usuario, String email, String password, String rol) async {
    final url = Uri.parse('$baseUrl/usuarios/');
    try {
      final headers = await getHeaders();
      final response = await http
          .post(
            url,
            headers: headers,
            body: json.encode({
              'usuario': usuario,
              'email': email,
              'password': password,
              'rol': rol,
            }),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  // Petición GET genérica
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    final response = await http.get(url, headers: headers).timeout(_timeout);
    return _handleResponse(response);
  }

  // Petición POST genérica
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    final response = await http
        .post(url, headers: headers, body: json.encode(body))
        .timeout(_timeout);
    return _handleResponse(response);
  }

  // Petición PUT genérica
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    final response = await http
        .put(url, headers: headers, body: json.encode(body))
        .timeout(_timeout);
    return _handleResponse(response);
  }

  // Petición DELETE genérica
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = await getHeaders();
    final response = await http.delete(url, headers: headers).timeout(_timeout);
    return _handleResponse(response);
  }

  // Manejo de la respuesta
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Por favor ingresá nuevamente.');
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      throw Exception('Error de API: ${response.statusCode} - ${response.body}');
    }
  }
}

final apiService = ApiService();
