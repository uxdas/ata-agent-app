// lib/core/services/point_fetch_service.dart

import 'package:dio/dio.dart';

class PointFetchService {
  final Dio dio;

  PointFetchService(this.dio);

  Future<List<Map<String, dynamic>>> fetchRegions() async {
    final response = await dio.get('/regions/');
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Ошибка при получении регионов');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCities(int regionId) async {
    final response = await dio.get('/regions/$regionId/cities/');
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Ошибка при получении городов');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPointTypes() async {
    final response = await dio.get('/point-types/');
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception('Ошибка при получении типов точек');
    }
  }
}
