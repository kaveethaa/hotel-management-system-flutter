import 'package:flutter/material.dart';
import 'package:hotel_management/data/models/models.dart';
import 'package:intl/intl.dart';

class ReservationSummaryCard extends StatelessWidget {
  final double roomPrice;
  final DateTime checkIn;
  final DateTime checkOut;

  const ReservationSummaryCard({
    super.key,
    required this.roomPrice,
    required this.checkIn,
    required this.checkOut, required Room room, required int nights,
  });

  @override
  Widget build(BuildContext context) {
    final nights =
    checkOut.difference(checkIn).inDays.clamp(1, 365);

    final subtotal = roomPrice * nights;
    final tax = subtotal * .10;
    final total = subtotal + tax;

    final money = NumberFormat.currency(symbol: "\$");

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade600,
            Colors.blue.shade500,
          ],
        ),
      ),
      child: Column(
        children: [

          const Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: Colors.white,
              ),

              SizedBox(width: 10),

              Text(
                "Booking Summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          _item(
            "Room Price",
            money.format(roomPrice),
          ),

          _item(
            "Nights",
            nights.toString(),
          ),

          _item(
            "Subtotal",
            money.format(subtotal),
          ),

          _item(
            "Tax (10%)",
            money.format(tax),
          ),

          const Divider(
            color: Colors.white30,
            height: 30,
          ),

          Row(
            children: [

              const Expanded(
                child: Text(
                  "Grand Total",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              Text(
                money.format(total),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}