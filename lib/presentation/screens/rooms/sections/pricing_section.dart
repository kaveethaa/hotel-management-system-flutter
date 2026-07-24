import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import 'basic_info_section.dart';
import '../widgets/modern_text_field.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController capacityController;

  const PricingSection({
    super.key,
    required this.priceController,
    required this.capacityController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Pricing & Capacity',
      icon: Icons.payments_outlined,
      child: Column(
        children: [
          ModernTextField(
            controller: priceController,
            label: 'Price per Night',
            hint: 'Enter room price',
            icon: Icons.currency_rupee_rounded,
            keyboardType: TextInputType.number,
            validator: (v) =>
            double.tryParse(v ?? '') == null ? 'Enter a valid price' : null,
          ),

          const SizedBox(height: 16),

          ModernTextField(
            controller: capacityController,
            label: 'Guest Capacity',
            hint: 'Maximum guests',
            icon: Icons.people_outline_rounded,
            keyboardType: TextInputType.number,
            validator: (v) =>
            int.tryParse(v ?? '') == null ? 'Enter a valid capacity' : null,
          ),
        ],
      ),
    );
  }
}
