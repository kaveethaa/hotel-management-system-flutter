import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueSection extends StatelessWidget {
  final dynamic stats;

  const RevenueSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Revenue',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 8),

          Text(
            NumberFormat.currency(symbol: '₹').format(stats.revenue),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 48,
                sectionsSpace: 4,
                sections: [
                  PieChartSectionData(
                    value: stats.available.toDouble(),
                    color: Colors.green,
                    title: 'Available',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: stats.occupied.toDouble(),
                    color: Colors.orange,
                    title: 'Occupied',
                    radius: 60,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}