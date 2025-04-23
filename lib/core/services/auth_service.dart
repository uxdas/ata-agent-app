// 📄 lib/core/services/auth_service.dart

import 'package:agent_pro/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class AuthService {
  final ApiClient api;

  AuthService(this.api);

  Future<bool> login({required String phone, required String password}) async {
    try {
      final response = await api.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return true;
      } else {
        log('Login error: ${response.statusCode}');
        return false;
      }
    } catch (e, s) {
      log('Login exception', error: e, stackTrace: s);
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }
}
