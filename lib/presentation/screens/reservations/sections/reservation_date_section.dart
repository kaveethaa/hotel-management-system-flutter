import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/section_card.dart';

class ReservationDateSection extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;

  final VoidCallback onCheckInTap;
  final VoidCallback onCheckOutTap;

  const ReservationDateSection({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onCheckInTap,
    required this.onCheckOutTap,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat("dd MMM yyyy");

    return SectionCard(
      title: "Stay Duration",
      icon: Icons.calendar_month_rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              children: [
                _DateCard(
                  title: "Check-In",
                  value: df.format(checkIn),
                  icon: Icons.login_rounded,
                  color: Colors.green,
                  onTap: onCheckInTap,
                ),

                const SizedBox(height: 14),

                _DateCard(
                  title: "Check-Out",
                  value: df.format(checkOut),
                  icon: Icons.logout_rounded,
                  color: Colors.red,
                  onTap: onCheckOutTap,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _DateCard(
                  title: "Check-In",
                  value: df.format(checkIn),
                  icon: Icons.login_rounded,
                  color: Colors.green,
                  onTap: onCheckInTap,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _DateCard(
                  title: "Check-Out",
                  value: df.format(checkOut),
                  icon: Icons.logout_rounded,
                  color: Colors.red,
                  onTap: onCheckOutTap,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DateCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(.08),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      value,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}