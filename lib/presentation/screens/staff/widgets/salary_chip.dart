import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalaryChip extends StatelessWidget {
  final double salary;

  const SalaryChip({
    super.key,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.green.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.payments_rounded,
            size: 18,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            NumberFormat.currency(
              symbol: "\$",
              decimalDigits: 0,
            ).format(salary),
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}