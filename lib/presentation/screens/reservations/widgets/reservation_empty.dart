import 'package:flutter/material.dart';

class ReservationEmpty extends StatelessWidget {
  const ReservationEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 70,
                color: Colors.blue.shade400,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "No Reservations Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "There are no reservations matching your selected filter.\nCreate a new reservation to get started.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: () {
                // Optional:
                // context.push('/reservations/form');
              },
              icon: const Icon(Icons.add),
              label: const Text("New Reservation"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}