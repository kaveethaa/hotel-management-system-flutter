import 'package:flutter/material.dart';

import '../widgets/modern_text_field.dart';
import '../widgets/section_card.dart';

class GuestBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  const GuestBasicInfoSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: "Basic Information",
      icon: Icons.person_outline_rounded,
      color: Colors.blue,
      child: Column(
        children: [
          ModernTextField(
            controller: nameController,
            label: "Full Name",
            hint: "Enter guest full name",
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Full name is required";
              }
              return null;
            },
          ),

          const SizedBox(height: 10),

          ModernTextField(
            controller: phoneController,
            label: "Phone Number",
            hint: "Enter phone number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Phone number is required";
              }

              if (value.length < 10) {
                return "Enter a valid phone number";
              }

              return null;
            },
          ),

          const SizedBox(height: 10),

          ModernTextField(
            controller: emailController,
            label: "Email Address",
            hint: "example@email.com",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }

              final emailRegEx = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              );

              if (!emailRegEx.hasMatch(value)) {
                return "Enter a valid email";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}