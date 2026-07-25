import 'package:flutter/material.dart';
import 'package:hotel_management/data/models/models.dart';

import '../widgets/modern_dropdown.dart';
import '../widgets/section_card.dart';

class ReservationGuestSection extends StatelessWidget {
  final String? selectedGuest;

  final List<DropdownMenuItem<String>> guestItems;

  final ValueChanged<String?> onChanged;

  const ReservationGuestSection({
    super.key,
    required this.selectedGuest,
    required this.guestItems,  required List<Guest> guestId, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Guest Information",
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          ModernDropdown<String>(
            value: selectedGuest,
            hint: "Select Guest",
            items: guestItems,
            onChanged: onChanged,
          ),

          if (selectedGuest != null) ...[
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Guest selected successfully.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}