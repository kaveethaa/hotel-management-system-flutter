import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
class DescriptionSection extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Description',
      icon: Icons.description_outlined,
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText:
          'Describe room features, amenities, view, bed type, etc.',
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}