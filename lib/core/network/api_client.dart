// 📄 lib/core/network/api_client.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: 'https://your-server.com/api')) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) => handler.next(e),
      onResponse: (r, handler) => handler.next(r),
    ));
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return dio.post(path, data: data);
  }

  Future<Response> get(String path) async {
    return dio.get(path);
  }
}