import 'package:flutter/material.dart';

class ReservationSubmitSection extends StatelessWidget {
  final bool isEdit;
  final bool loading;
  final VoidCallback onPressed;

  const ReservationSubmitSection({
    super.key,
    required this.isEdit,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            onPressed: loading ? null : onPressed,
            icon: loading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : Icon(
              isEdit
                  ? Icons.save_rounded
                  : Icons.check_circle_rounded,
            ),
            label: Text(
              loading
                  ? "Saving..."
                  : isEdit
                  ? "Update Reservation"
                  : "Create Reservation",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          "The room availability will be verified before saving.",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}