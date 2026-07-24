import 'package:flutter/material.dart';

class RoomsStatsSection extends StatelessWidget {
  final List<dynamic> rooms;

  const RoomsStatsSection({
    super.key,
    required this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    final available =
        rooms.where((r) => r.status == 'Available').length;
    final occupied =
        rooms.where((r) => r.status == 'Occupied').length;

    return Row(
      children: [
        Expanded(
          child: _StatTile(
            title: 'Total',
            value: '${rooms.length}',
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            title: 'Available',
            value: '$available',
            color: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            title: 'Occupied',
            value: '$occupied',
            color: const Color(0xFFEA580C),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatTile({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}