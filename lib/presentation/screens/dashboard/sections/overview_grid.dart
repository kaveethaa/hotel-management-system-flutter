import 'package:flutter/material.dart';

import '../widgets/stat_card.dart';

class OverviewGrid extends StatelessWidget {
  final dynamic stats;

  const OverviewGrid({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.15,
          children: [
            StatCard(
              icon: Icons.meeting_room,
              label: 'Total Rooms',
              value: '${stats.total}',
              color: Colors.blue,
            ),
            StatCard(
              icon: Icons.check_circle,
              label: 'Available',
              value: '${stats.available}',
              color: Colors.green,
            ),
            StatCard(
              icon: Icons.hotel,
              label: 'Occupied',
              value: '${stats.occupied}',
              color: Colors.orange,
            ),
            StatCard(
              icon: Icons.percent,
              label: 'Occupancy',
              value: '${stats.occupancy.toStringAsFixed(0)}%',
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}