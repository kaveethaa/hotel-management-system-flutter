import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';
import 'package:intl/intl.dart';

class StaffHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final List<Staff>? staff;

  const StaffHeader({
    super.key,
    this.staff,
  });

  @override
  Widget build(BuildContext context) {
    final totalStaff = staff?.length ?? 0;

    final totalSalary = staff == null
        ? 0.0
        : staff!
        .fold(
      0.0,
          (sum, item) => sum + item.salary,
    );

    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff3949AB),
              Color(0xff5C6BC0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Staff Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _infoCard(
                        icon: Icons.groups,
                        title: "Employees",
                        value: totalStaff.toString(),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: _infoCard(
                        icon: Icons.payments,
                        title: "Payroll",
                        value: NumberFormat.currency(
                          symbol: "\$",
                          decimalDigits: 0,
                        ).format(totalSalary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(165);
}