import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final _storage = const FlutterSecureStorage();

  Future<User> login(String email, String password) async {
    final response = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
      return await getCurrentUser();
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Invalid email or password');
    }
  }

  Future<User> register(String email, String password, String fullName) async {
    final response = await _api.post('/auth/register', {
      'email': email,
      'password': password,
      'full_name': fullName,
    });
    if (response.statusCode == 201) {
      return await login(email, password);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Registration failed');
    }
  }

  Future<User> getCurrentUser() async {
    final response = await _api.get('/auth/me');
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Session expired');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}
