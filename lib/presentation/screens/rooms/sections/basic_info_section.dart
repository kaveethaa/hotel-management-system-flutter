import 'package:flutter/material.dart';
import '../widgets/modern_dropdown.dart';
import '../widgets/modern_text_field.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController numberController;
  final String type;
  final String status;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onStatusChanged;

  const BasicInfoSection({
    super.key,
    required this.numberController,
    required this.type,
    required this.status,
    required this.onTypeChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Basic Information',
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          ModernTextField(
            controller: numberController,
            label: 'Room Number',
            hint: 'e.g. 101',
            icon: Icons.confirmation_number_rounded,
            validator: (v) =>
            v == null || v.isEmpty ? 'Room number is required' : null,
          ),

          const SizedBox(height: 16),

          ModernDropdown(
            label: 'Room Type',
            value: type,
            items: const ['Standard', 'Deluxe', 'Suite'],
            icon: Icons.king_bed_rounded,
            onChanged: onTypeChanged,
          ),

          const SizedBox(height: 16),

          ModernDropdown(
            label: 'Status',
            value: status,
            items: const [
              'Available',
              'Occupied',
              'Reserved',
              'Cleaning',
              'Maintenance'
            ],
            icon: Icons.hotel_class_rounded,
            onChanged: onStatusChanged,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1E88E5)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}