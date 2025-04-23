// lib/features/orders/screens/order_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:agent_pro/core/models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
        backgroundColor: Colors.pink[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Номер заказа', order.id),
                    const SizedBox(height: 8),
                    _buildDetailRow('Клиент', order.clientName),
                    const SizedBox(height: 8),
                    _buildDetailRow('Дистрибьютор', order.distributorName),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Дата',
                      '${order.orderDate.day}.${order.orderDate.month}.${order.orderDate.year}',
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Тип заказа', order.orderType),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Товары (${order.items.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...order.items.map((item) => _buildProductItem(item)).toList(),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Итого:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${order.total.toStringAsFixed(2)}₽',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildProductItem(OrderItemModel item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pink[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shopping_bag, color: Colors.pink),
        ),
        title: Text(
          item.productName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${item.quantity} шт. × ${item.price.toStringAsFixed(2)}₽'),
        trailing: Text(
          '${item.total.toStringAsFixed(2)}₽',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
