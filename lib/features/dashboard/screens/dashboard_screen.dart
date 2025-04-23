import 'package:agent_pro/core/constants/server.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_drawer.dart';
import '../widgets/last_order_summary.dart';
import '../widgets/order_chart.dart';
import 'package:dio/dio.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? agentData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadAgentData();
  }

  Future<void> _loadAgentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          error = 'Токен не найден';
          isLoading = false;
        });
        return;
      }

      final dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: {'Authorization': 'Token $token'},
      ));

      final response = await dio.get('/agents/me/');

      if (response.statusCode == 200) {
        setState(() {
          agentData = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Ошибка: ${response.statusCode}';
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
    final name =
        '${agentData?['first_name'] ?? 'Бексултан'} ${agentData?['second_name'] ?? ''}';
    final ordersCount = agentData?['orders_count']?.toString() ?? '—';
    final pointsCount = agentData?['points_count']?.toString() ?? '—';

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Панель агента'),
        backgroundColor: const Color(0xFF3C4D6D),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF222222),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.white)))
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _AgentHeader(name: name),
          const SizedBox(height: 20),
          const LastOrderSummaryStyled(),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Статистика'),
          _StatCard(icon: Icons.shopping_cart, label: 'Заказов', value: ordersCount),
          _StatCard(icon: Icons.store, label: 'Точек', value: pointsCount),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'График заказов'),
          const SizedBox(height: 12),
          const _GraphCard(),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Быстрые действия'),
          const SizedBox(height: 12),
          const _ActionGrid(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _AgentHeader extends StatelessWidget {
  final String name;
  const _AgentHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C4D6D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/avatar.png'),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Добро пожаловать',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2E2E2E),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.white70),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _ActionTile(
            icon: Icons.add_shopping_cart,
            label: 'Добавить заказ',
            route: '/add_order',
            color: Color(0xFF6C5B3B),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _ActionTile(
            icon: Icons.store_mall_directory,
            label: 'Создать точку',
            route: '/create_point',
            color: Color(0xFF3C4D6D),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final Color color;

  const _ActionTile({required this.icon, required this.label, required this.route, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphCard extends StatelessWidget {
  const _GraphCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2E2E2E),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: SizedBox(height: 200, child: OrderChart()),
      ),
    );
  }
}

class LastOrderSummaryStyled extends StatelessWidget {
  const LastOrderSummaryStyled({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 3,
      color: Color(0xFF2E2E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: LastOrderSummary(),
      ),
    );
  }
}