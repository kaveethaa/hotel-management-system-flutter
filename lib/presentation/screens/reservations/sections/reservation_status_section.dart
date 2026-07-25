import 'package:flutter/material.dart';

import '../widgets/modern_dropdown.dart';
import '../widgets/section_card.dart';

class ReservationStatusSection extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const ReservationStatusSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'Reserved':
        return Colors.blue;
      case 'Checked-In':
        return Colors.green;
      case 'Checked-Out':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Reserved':
        return Icons.bookmark_added_rounded;
      case 'Checked-In':
        return Icons.login_rounded;
      case 'Checked-Out':
        return Icons.logout_rounded;
      case 'Cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(value);

    return SectionCard(
      title: "Reservation Status",
      icon: Icons.flag_circle_rounded,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(.12),
                child: Icon(
                  _statusIcon(value),
                  color: color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ModernDropdown<String>(
            value: value,
            hint: "Reservation Status",
            onChanged: onChanged,
            items: const [
              DropdownMenuItem(
                value: "Reserved",
                child: Text("Reserved"),
              ),
              DropdownMenuItem(
                value: "Checked-In",
                child: Text("Checked-In"),
              ),
              DropdownMenuItem(
                value: "Checked-Out",
                child: Text("Checked-Out"),
              ),
              DropdownMenuItem(
                value: "Cancelled",
                child: Text("Cancelled"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}