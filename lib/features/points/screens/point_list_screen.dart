import 'dart:developer';
import 'package:agent_pro/core/constants/server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Модель точки
class RetailPoint {
  final int id;
  final String name;
  final String address;
  final String city;
  final String retailerType;

  RetailPoint({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.retailerType,
  });

  factory RetailPoint.fromJson(Map<String, dynamic> json) {
    return RetailPoint(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city']?['name'] ?? '—',
      retailerType: json['retailer_type']?['title'] ?? '—',
    );
  }
}

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  Future<List<RetailPoint>>? _futurePoints;


  @override
  void initState() {
    super.initState();
    _futurePoints = fetchRetailPoints();
  }

  Future<List<RetailPoint>> fetchRetailPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Token $token',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await dio.get('/agents/my-retailers');

      final List<dynamic> data = response.data;
      return data.map((json) => RetailPoint.fromJson(json)).toList();
    } catch (e, stack) {
      log('Ошибка при загрузке точек: $e\n$stack');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои точки')),
      body: FutureBuilder<List<RetailPoint>>(
        future: _futurePoints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет добавленных точек'));
          }

          final points = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: points.length,
            itemBuilder: (context, index) {
              final p = points[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(p.name),
                  subtitle: Text('${p.retailerType} • ${p.city}\n${p.address}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    log('Нажали на точку: ${p.id}');
                    // TODO: Переход на экран заказов
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
