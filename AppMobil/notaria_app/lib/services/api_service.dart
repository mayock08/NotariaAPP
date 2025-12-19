import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import '../models/expediente.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'https://localhost:5001/api';
  final AuthService _authService = AuthService();

  Future<UserProfile?> getProfile() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/person/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else if (response.statusCode == 401) {
        print('Unauthorized - token may be expired');
        await _authService.logout();
        return null;
      } else {
        print('Get profile failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  Future<Expediente?> getExpediente(int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/expediente/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Expediente.fromJson(data);
      } else if (response.statusCode == 401) {
        print('Unauthorized - token may be expired');
        await _authService.logout();
        return null;
      } else {
        print('Get expediente failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get expediente error: $e');
      return null;
    }
  }

  Future<List<Expediente>> getMyExpedientes() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/expediente/my-expedientes'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Expediente.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        print('Unauthorized - token may be expired');
        await _authService.logout();
        return [];
      } else {
        print('Get expedientes failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get expedientes error: $e');
      return [];
    }
  }

  Future<bool> sendTestNotification(String deviceToken) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/notification/test'),
        headers: headers,
        body: jsonEncode({'deviceToken': deviceToken}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Send notification error: $e');
      return false;
    }
  }
}
