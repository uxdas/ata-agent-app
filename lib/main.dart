import 'package:agent_pro/features/orders/screens/order_history_screen.dart';
import 'package:agent_pro/features/points/screens/point_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:agent_pro/core/models/order_model.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/orders/screens/add_order_screen.dart';
import 'features/orders/screens/order_list_screen.dart';
import 'features/orders/screens/order_detail_screen.dart';
import 'features/points/screens/create_point_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agent Pro',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/add_order': (_) => const AddOrderScreen(),
        '/order_list': (_) => const OrderListScreen(),
        '/order_detail': (ctx) {
          final order = ModalRoute.of(ctx)!.settings.arguments as OrderModel;
          return OrderDetailScreen(order: order);
        },
        '/create_point': (_) => const CreatePointScreen(),
        '/points': (_) => const PointsScreen(),
        '/order_history_screen': (_) => OrderHistoryScreen(),
      },
    );
  }
}
