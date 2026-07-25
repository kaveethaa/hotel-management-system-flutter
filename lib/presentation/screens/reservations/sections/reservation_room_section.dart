import 'package:flutter/material.dart';
import 'package:hotel_management/data/models/models.dart';

import '../widgets/modern_dropdown.dart';
import '../widgets/section_card.dart';

class ReservationRoomSection extends StatelessWidget {
  final String? selectedRoom;
  final List<DropdownMenuItem<String>> roomItems;
  final ValueChanged<String?> onChanged;

  const ReservationRoomSection({
    super.key,
    required this.selectedRoom,
    required this.roomItems,
    required this.onChanged, required List<Room> rooms,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Room Information",
      icon: Icons.hotel_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernDropdown<String>(
            value: selectedRoom,
            hint: "Select Room",
            items: roomItems,
            onChanged: onChanged,
          ),

          if (selectedRoom != null) ...[
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Room selected successfully.",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}