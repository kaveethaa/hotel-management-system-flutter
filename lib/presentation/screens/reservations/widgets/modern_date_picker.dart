import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModernDatePicker extends StatelessWidget {
  final String title;
  final DateTime date;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ModernDatePicker({
    super.key,
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: color.withOpacity(.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(.20),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      df.format(date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.edit_calendar_rounded,
                color: color,
              )
            ],
          ),
        ),
      ),
    );
  }
}