import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrderChart extends StatelessWidget {
  const OrderChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        backgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                return Text(days[value.toInt()], style: const TextStyle(color: Colors.white));
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 3, color: Colors.teal)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: Colors.teal)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4, color: Colors.teal)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 5, color: Colors.teal)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 8, color: Colors.teal)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 4, color: Colors.teal)]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 7, color: Colors.teal)]),
        ],
      ),
    );
  }
}
