import 'package:flutter/material.dart';

class RoomFilterChips extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const RoomFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const statuses = [
    'All',
    'Available',
    'Occupied',
    'Reserved',
    'Cleaning',
    'Maintenance',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final status = statuses[index];
          final isSelected = selected == status;

          return ChoiceChip(
            label: Text(status),
            selected: isSelected,
            selectedColor: const Color(0xFF1E88E5),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onChanged(status),
          );
        },
      ),
    );
  }
}