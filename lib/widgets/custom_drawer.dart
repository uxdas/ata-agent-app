import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<String> _getAgentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('agent_name') ?? 'Watashi Adiretu';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            FutureBuilder<String>(
              future: _getAgentName(),
              builder: (context, snapshot) {
                final name = snapshot.data ?? 'Watashi Adiretu';
                return Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.indigo,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'agent@example.com',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Главная'),
              onTap: () => Navigator.pushReplacementNamed(context, '/dashboard'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Добавить заказ'),
              onTap: () => Navigator.pushNamed(context, '/add_order'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Создать точку'),
              onTap: () => Navigator.pushNamed(context, '/create_point'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Войти'),
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Список точки'),
              onTap: () => Navigator.pushNamed(context, '/points'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('История заказов'),
              onTap: () => Navigator.pushNamed(context, '/order_history_screen')
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Выйти', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                await prefs.remove('agent_name');
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
