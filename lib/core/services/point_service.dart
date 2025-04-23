// lib/core/services/point_api_service.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PointApiService {
  final Dio dio;

  PointApiService(this.dio);

  Future<void> createPoint(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await dio.post(
      '/points/',
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Ошибка при добавлении точки: ${response.statusCode}');
    }
  }
}
