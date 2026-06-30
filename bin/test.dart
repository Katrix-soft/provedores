import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Iniciando prueba de conexión con la API...');
  final urlLogin = Uri.parse('http://localhost:8000/auth/login');
  
  try {
    final response = await http.post(
      urlLogin,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': 'admin', 'password': 'admin_password'}) // I don't know the password, maybe admin / admin?
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
