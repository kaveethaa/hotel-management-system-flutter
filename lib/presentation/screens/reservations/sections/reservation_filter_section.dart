import 'package:flutter/material.dart';

class ReservationFilterSection extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const ReservationFilterSection({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  static const List<String> _statuses = [
    'All',
    'Reserved',
    'Checked-In',
    'Checked-Out',
    'Cancelled',
  ];

  Color _chipColor(String status) {
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
        return Colors.indigo;
    }
  }

  IconData _chipIcon(String status) {
    switch (status) {
      case 'Reserved':
        return Icons.book_online_outlined;
      case 'Checked-In':
        return Icons.login_rounded;
      case 'Checked-Out':
        return Icons.logout_rounded;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.apps_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final status = _statuses[index];
          final isSelected = status == selectedStatus;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: FilterChip(
              selected: isSelected,
              showCheckmark: false,
              avatar: Icon(
                _chipIcon(status),
                size: 18,
                color: isSelected
                    ? Colors.white
                    : _chipColor(status),
              ),
              label: Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              backgroundColor: Colors.white,
              selectedColor: _chipColor(status),
              side: BorderSide(
                color: isSelected
                    ? _chipColor(status)
                    : Colors.grey.shade300,
              ),
              elevation: isSelected ? 4 : 0,
              shadowColor: _chipColor(status).withOpacity(.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onSelected: (_) => onChanged(status),
            ),
          );
        },
      ),
    );
  }
}