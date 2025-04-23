import 'package:flutter/material.dart';

class BonusesScreen extends StatelessWidget {
  const BonusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        title: const Text('Мои бонусы'),
        backgroundColor: const Color(0xFF3C4D6D),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _BonusBalance(),
          SizedBox(height: 24),
          _BonusHistoryItem(
            title: 'Заказ от 12.04.2025',
            amount: '+150',
            date: '12.04.2025',
            positive: true,
          ),
          _BonusHistoryItem(
            title: 'Потрачено на подарок',
            amount: '-100',
            date: '10.04.2025',
            positive: false,
          ),
          _BonusHistoryItem(
            title: 'Начисление за точку',
            amount: '+75',
            date: '08.04.2025',
            positive: true,
          ),
        ],
      ),
    );
  }
}

class _BonusBalance extends StatelessWidget {
  const _BonusBalance();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Ваш баланс бонусов',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            '345 ₽',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _BonusHistoryItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final bool positive;

  const _BonusHistoryItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2E2E2E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          positive ? Icons.trending_up : Icons.trending_down,
          color: positive ? Colors.greenAccent : Colors.redAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          amount,
          style: TextStyle(
            color: positive ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
