import 'package:flutter/material.dart';

import '../widgets/modern_text_field.dart';
import '../widgets/section_card.dart';

class GuestAddressSection extends StatelessWidget {
  final TextEditingController controller;

  const GuestAddressSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Address",
      icon: Icons.location_on_outlined,
      color: Colors.teal,
      child: Column(
        children: [
          ModernTextField(
            controller: controller,
            label: "Guest Address",
            hint: "Enter full address",
            icon: Icons.home_outlined,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}