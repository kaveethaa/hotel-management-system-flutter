import 'package:flutter/material.dart';

import '../widgets/modern_dropdown.dart';
import '../widgets/modern_text_field.dart';
import '../widgets/section_card.dart';

class GuestIdentitySection extends StatelessWidget {
  final String idType;
  final TextEditingController idNumberController;
  final ValueChanged<String?> onChanged;

  const GuestIdentitySection({
    super.key,
    required this.idType,
    required this.idNumberController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Identity Information",
      icon: Icons.badge_outlined,
      color: Colors.deepPurple,
      child: Column(
        children: [
          ModernDropdown<String>(
            label: "ID Type",
            icon: Icons.credit_card_outlined,
            value: idType,
            items: const [
              "Passport",
              "Driving License",
              "Aadhaar",
              "National ID",
            ],
            onChanged: onChanged,
          ),

          const SizedBox(height: 10),

          ModernTextField(
            controller: idNumberController,
            label: "ID Number",
            hint: "Enter ID number",
            icon: Icons.confirmation_number_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "ID Number is required";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}