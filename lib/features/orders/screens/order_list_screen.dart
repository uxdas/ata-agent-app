// lib/features/orders/screens/order_list_screen.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  bool isLoading = true;
  String? error;
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() => error = 'Нет токена');
        return;
      }

      final dio = Dio(BaseOptions(
        baseUrl: 'https://8610-46-251-192-226.ngrok-free.app',
        headers: {'Authorization': 'Bearer $token'},
      ));

      final response = await dio.get('/orders/');

      if (response.statusCode == 200) {
        setState(() {
          orders = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Ошибка загрузки: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Ошибка: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: orders.length,
        itemBuilder: (_, index) {
          final order = orders[index];
          final clientName = order['client_name'] ?? 'Без клиента';
          final date = order['order_date'] ?? '';
          final total = order['total']?.toStringAsFixed(2) ?? '—';

          return ListTile(
            title: Text(clientName),
            subtitle: Text('Дата: $date'),
            trailing: Text('$total ₽', style: const TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/order_detail',
                arguments: order,
              );
            },
          );
        },
      ),
    );
  }
}
