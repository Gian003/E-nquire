import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:enquire/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  Map<String, dynamic>? get user => _user;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      if (response['success'] == true) {
        _user = response['data']['user'];
        _isAuthenticated = true;
        _error = null;
      } else {
        _error = response['message'] ?? 'Login failed';
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(Map<String, dynamic> userdata) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.register(userdata);

      if (response['success'] == true) {
        _user = response['data']['user'];
        _isAuthenticated = true;
        _error = null;
      } else {
        _error = response['message'] ?? 'Registration Failed';
        _isAuthenticated = false;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthentication() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userData = await _apiService.getStoredUser();
      if (userData != null) {
        _user = userData;
        _isAuthenticated = true;
      } else {
        //Get fresh user data
        final response = await _apiService.getUserProfile();
        if (response['success'] == true) {
          _user = response['data']['user'];
          _isAuthenticated = true;
          await _storage.write(key: 'user_data', value: json.encode(_user));
        } else {
          await logout();
        }
      }
    } catch (e) {
      print('Authentication check error: $e');
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
