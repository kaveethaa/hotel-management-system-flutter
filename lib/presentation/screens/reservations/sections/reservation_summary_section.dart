import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/section_card.dart';

class ReservationSummarySection extends StatelessWidget {
  final double roomPrice;
  final DateTime checkIn;
  final DateTime checkOut;

  const ReservationSummarySection({
    super.key,
    required this.roomPrice,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  Widget build(BuildContext context) {
    final nights = checkOut.difference(checkIn).inDays.clamp(1, 365);
    final subtotal = roomPrice * nights;
    final tax = subtotal * 0.10;
    final total = subtotal + tax;

    final money = NumberFormat.currency(symbol: "\$");

    return SectionCard(
      title: "Booking Summary",
      icon: Icons.receipt_long_rounded,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [

            _SummaryTile(
              icon: Icons.king_bed_rounded,
              label: "Room Price",
              value: "${money.format(roomPrice)} / night",
            ),

            const Divider(height: 28),

            _SummaryTile(
              icon: Icons.hotel_rounded,
              label: "Nights",
              value: "$nights",
            ),

            const Divider(height: 28),

            _SummaryTile(
              icon: Icons.payments_outlined,
              label: "Subtotal",
              value: money.format(subtotal),
            ),

            const Divider(height: 28),

            _SummaryTile(
              icon: Icons.receipt_rounded,
              label: "Tax (10%)",
              value: money.format(tax),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [

                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "Grand Total",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Text(
                    money.format(total),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade50,
          child: Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}