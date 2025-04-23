import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options); // продолжить запрос
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Можно отлавливать 401 и делать разлогин
    return handler.next(err);
  }
}
