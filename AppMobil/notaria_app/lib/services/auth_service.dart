import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  // Change this to your backend URL
  // For local development: http://10.0.2.2:5001 (Android emulator)
  // For iOS simulator: http://localhost:5001
  // For production: https://your-api-url.com
  static const String baseUrl = 'https://localhost:5001/api';
  
  final _storage = const FlutterSecureStorage();
  
  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        
        // Store token securely
        await _storage.write(key: 'jwt_token', value: user.token);
        await _storage.write(key: 'user_email', value: user.email);
        await _storage.write(key: 'user_name', value: user.fullName);
        
        return user;
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }
}
