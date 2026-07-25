import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/datasources/local/database_helper.dart';

final weeklyRevenueProvider = FutureProvider<List<double>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final now = DateTime.now();
  final data = <double>[];
  for (int i = 6; i >= 0; i--) {
    final d = DateTime(now.year, now.month, now.day - i);
    final start = d.toIso8601String();
    final end = d.add(const Duration(days: 1)).toIso8601String();
    final r = await db.rawQuery(
        'SELECT SUM(total) as s FROM bills WHERE status=? AND created_at BETWEEN ? AND ?',
        ['Paid', start, end]);
    data.add((r.first['s'] as num?)?.toDouble() ?? 0);
  }
  return data;
});

final roomTypeDistProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  final rows = await db.rawQuery('SELECT type, COUNT(*) as c FROM rooms GROUP BY type');
  return {for (final r in rows) r['type'] as String: r['c'] as int};
});

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rev = ref.watch(weeklyRevenueProvider);
    final types = ref.watch(roomTypeDistProvider);

    final labels = List.generate(7, (i) {
      final d = DateTime.now().subtract(Duration(days: 6 - i));
      return DateFormat('E').format(d);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// Weekly Revenue
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Weekly Revenue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 220,
                    child: rev.when(
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text(e.toString())),
                      data: (data) {
                        return LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),

                            borderData: FlBorderData(show: false),

                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '\$${value.toInt()}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();

                                    if (index >= 0 &&
                                        index < labels.length) {
                                      return Text(
                                        labels[index],
                                        style:
                                        const TextStyle(fontSize: 10),
                                      );
                                    }

                                    return const SizedBox();
                                  },
                                ),
                              ),

                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),

                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  data.length,
                                      (i) =>
                                      FlSpot(
                                        i.toDouble(),
                                        data[i],
                                      ),
                                ),
                                isCurved: true,
                                color: const Color(0xFFD4AF37),
                                barWidth: 3,
                                dotData:
                                const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: const Color(0xFFD4AF37)
                                      .withOpacity(0.2),
// Flutter 3.27+
// .withValues(alpha: 0.2),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Room Type Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Rooms by Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 200,
                    child: types.when(
                      loading: () =>
                      const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text(e.toString())),
                      data: (map) {
                        final colors = [
                          const Color(0xFF1A2B4A),
                          const Color(0xFFD4AF37),
                          const Color(0xFFE8C86A),
                        ];

                        final entries = map.entries.toList();

                        return PieChart(
                          PieChartData(
                            sections: List.generate(
                              entries.length,
                                  (i) =>
                                  PieChartSectionData(
                                    value:
                                    entries[i].value.toDouble(),
                                    title:
                                    '${entries[i].key}\n${entries[i].value}',
                                    color:
                                    colors[i % colors.length],
                                    radius: 70,
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
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