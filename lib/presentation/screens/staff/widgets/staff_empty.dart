import 'package:flutter/material.dart';

class StaffEmpty extends StatelessWidget {
  const StaffEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_rounded,
              size: 110,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              "No Staff Found",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Add your first employee to start managing your hotel staff.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add),
              label: const Text("Add Staff"),
            )
          ],
        ),
      ),
    );
  }
}