import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();
  // Read the saved JWT and builds the headers every authentication request needs
  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String endpoint) async {
    final header = await _authHeaders();
    return http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: header,
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final header = await _authHeaders();
    return http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: header,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final header = await _authHeaders();
    return http.put(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: header,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final header = await _authHeaders();
    return http.delete(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: header
    ); 
  }
}