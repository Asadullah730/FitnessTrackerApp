import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CaloriesBarChart extends StatelessWidget {
  final Map<String, int> data;

  const CaloriesBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final barGroups =
        data.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value.key;
          final calories = entry.value.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: calories.toDouble(),
                color: Colors.deepPurple,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList();

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (index, _) {
                  final key = data.keys.toList()[index.toInt()];
                  return Text(
                    key.split(" ").first, // Just show day (e.g. "Aug")
                    style: TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
