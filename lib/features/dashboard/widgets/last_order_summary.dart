import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastOrderSummary extends StatefulWidget {
  const LastOrderSummary({super.key});

  @override
  State<LastOrderSummary> createState() => _LastOrderSummaryState();
}

class _LastOrderSummaryState extends State<LastOrderSummary> {
  String? product;
  int? qty;

  @override
  void initState() {
    super.initState();
    _loadLastOrder();
  }

  Future<void> _loadLastOrder() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      product = prefs.getString('last_product');
      qty = prefs.getInt('last_qty');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: product != null && qty != null
            ? Row(
          children: [
            const Icon(Icons.history, color: Colors.indigo),
            const SizedBox(width: 12),
            Text(
              'Последний заказ: $product × $qty',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        )
            : const Text('Нет данных о последнем заказе'),
      ),
    );
  }
}
