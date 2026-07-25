import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';

class StaffCard extends StatelessWidget {
  final Staff staff;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const StaffCard({
    super.key,
    required this.staff,
    this.onTap,
    this.onDelete,
  });

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case "manager":
        return Colors.deepPurple;
      case "chef":
        return Colors.orange;
      case "receptionist":
        return Colors.blue;
      case "housekeeping":
        return Colors.teal;
      case "security":
        return Colors.red;
      case "maintenance":
        return Colors.green;
      default:
        return Colors.indigo;
    }
  }

  IconData _roleIcon(String role) {
    switch (role.toLowerCase()) {
      case "manager":
        return Icons.badge;
      case "chef":
        return Icons.restaurant;
      case "receptionist":
        return Icons.support_agent;
      case "housekeeping":
        return Icons.cleaning_services;
      case "security":
        return Icons.security;
      case "maintenance":
        return Icons.handyman;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _roleColor(staff.role);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: roleColor.withOpacity(.15),
                child: Icon(
                  _roleIcon(staff.role),
                  color: roleColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        staff.role,
                        style: TextStyle(
                          color: roleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(staff.phone)),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.email, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(staff.email)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "\$${staff.salary.toStringAsFixed(0)} / month",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") {
                    onTap?.call();
                  } else if (value == "delete") {
                    onDelete?.call();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: "edit",
                    child: Text("Edit"),
                  ),
                  PopupMenuItem(
                    value: "delete",
                    child: Text("Delete"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}