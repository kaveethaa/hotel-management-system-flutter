import 'package:flutter/material.dart';

class ReservationStatusChip extends StatelessWidget {
  final String status;

  const ReservationStatusChip({
    super.key,
    required this.status,
  });

  Color get color {
    switch (status) {
      case "Reserved":
        return Colors.blue;

      case "Checked-In":
        return Colors.green;

      case "Checked-Out":
        return Colors.orange;

      case "Cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (status) {
      case "Reserved":
        return Icons.book_online_rounded;

      case "Checked-In":
        return Icons.login_rounded;

      case "Checked-Out":
        return Icons.logout_rounded;

      case "Cancelled":
        return Icons.cancel_rounded;

      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),

          const SizedBox(width: 6),

          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}