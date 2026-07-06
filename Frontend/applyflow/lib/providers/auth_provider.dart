import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // Variable Declaration
  final _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  //--------------------Login()---------------------------|
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //--------------------Logout()---------------------------|
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  //--------------------tryAutoLogin()---------------------------|
  Future<void> tryAutoLogin() async {
    if (await _authService.isLoggedIn()) {
      try {
        _currentUser = await _authService.getCurrentUser();
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        await logout(); 
      }
    }
  }
}
