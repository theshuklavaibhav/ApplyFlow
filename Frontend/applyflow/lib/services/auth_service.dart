// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/user.dart';
// import 'api_service.dart';

// class AuthService {
//   final ApiService _api = ApiService();
//   final _storage = const FlutterSecureStorage();

//   Future<User> login(String email, String password) async {
//     final response = await _api.post('auth.login', {
//       'email': email,
//       'password': password,
//     });

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // Save Both tokens on device storage
//       await _storage.write(key: 'access_token', value: data['access_token']);
//       await _storage.write(key: 'refresh_token', value: data['refresh_token']);
//       return await getCurrentUser();
//     } else {
//       throw Exception('Invalid Email or Password');
//     }
//   }

//   Future<User> register(String email, String password, String fullName) async {
//     final response = await _api.post('/auth/register', {
//       'email': email,
//       'password': password,
//       'full_Name': fullName,
//     });
//     if (response.statusCode == 201) {
//       // After Registration Returen user directly to login
//       return await login(email, password);
//     } else {
//       throw Exception("Registration failed. email is already be in use");
//     }
//   }

//   Future<User> getCurrentUser() async {
//     final response = await _api.get('auth/me');
//     if (response.statusCode == 201) {
//       return User.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Session Expired');
//     }
//   }

//   Future<void> logout() async {
//     await _storage.delete(key: 'access_tokken');
//     await _storage.delete(key: 'refresh_tokken');
//   }

//   Future<bool> isLoggedIn() async {
//     final token = await _storage.read(key: 'access_token');
//     return (token != null); 
//   }
// }


import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login
  Future<User> login(String email, String password) async {
    final response = await _api.post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await _storage.write(
        key: 'access_token',
        value: data['access_token'],
      );

      await _storage.write(
        key: 'refresh_token',
        value: data['refresh_token'],
      );

      return await getCurrentUser();
    }

    final error = jsonDecode(response.body);
    throw Exception(error['detail'] ?? 'Invalid email or password');
  }

  /// Register
  Future<User> register(
    String email,
    String password,
    String fullName,
  ) async {
    final response = await _api.post(
      '/auth/register',
      {
        'email': email,
        'password': password,
        'full_name': fullName,
      },
    );

    if (response.statusCode == 201) {
      return await login(email, password);
    }

    final error = jsonDecode(response.body);
    throw Exception(error['detail'] ?? 'Registration failed');
  }

  /// Current Logged In User
  Future<User> getCurrentUser() async {
    final response = await _api.get('/auth/me');

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception('Session expired');
  }

  /// Logout
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  /// Check Login
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }
}