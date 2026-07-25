import 'package:flutter/material.dart';

class GuestStatsSection extends StatelessWidget {
  final List<dynamic> guests;

  const GuestStatsSection({
    super.key,
    required this.guests,
  });

  @override
  Widget build(BuildContext context) {
    final total = guests.length;
    final aadhaar =
        guests.where((g) => g.idType == 'Aadhaar').length;
    final passport =
        guests.where((g) => g.idType == 'Passport').length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total',
            value: '$total',
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Aadhaar',
            value: '$aadhaar',
            color: const Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Passport',
            value: '$passport',
            color: const Color(0xFFEA580C),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
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
              fontSize: 18,
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