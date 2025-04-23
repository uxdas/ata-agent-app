import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'История заказов',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderHistoryScreen(),
    );
  }
}

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  // Простой список заказов (данные в памяти)
  List<Map<String, dynamic>> orders = [
    {'productName': 'Товар 1', 'quantity': 2, 'price': 50.0, 'orderDate': '2025-04-21'},
    {'productName': 'Товар 2', 'quantity': 1, 'price': 100.0, 'orderDate': '2025-04-20'},
    {'productName': 'Товар 3', 'quantity': 5, 'price': 30.0, 'orderDate': '2025-04-19'},
  ];

  void repeatOrder(Map<String, dynamic> order) {
    // Логика для повторного заказа (просто добавляем новый заказ с такими же данными)
    setState(() {
      orders.add({
        'productName': order['productName'],
        'quantity': order['quantity'],
        'price': order['price'],
        'orderDate': DateTime.now().toString().substring(0, 10), // текущая дата
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('История заказов')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text(order['productName']),
            subtitle: Text('Количество: ${order['quantity']}, Сумма: \$${(order['price'] * order['quantity']).toStringAsFixed(2)}'),
            trailing: ElevatedButton(
              onPressed: () => repeatOrder(order), // Повторить заказ
              child: Text('Повторить заказ'),
            ),
          );
        },
      ),
    );
  }
}

