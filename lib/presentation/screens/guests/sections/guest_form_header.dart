import 'package:flutter/material.dart';

import '../widgets/guest_profile_preview.dart';

class GuestFormHeader extends StatelessWidget {
  final bool isEdit;
  final String guestName;

  const GuestFormHeader({
    super.key,
    required this.isEdit,
    required this.guestName,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 10,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff1565C0),
            Color(0xff42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          /// Top Bar
          Row(
            children: [
              Material(
                color: Colors.white.withOpacity(.15),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
              ),

              const Spacer(),

              Text(
                isEdit ? "Edit Guest" : "Register Guest",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const Spacer(),

             // const SizedBox(width: 20),
            ],
          ),

         // const SizedBox(height: 12),

          /// Guest Preview
          GuestProfilePreview(
            guestName: guestName,
          ),

          const SizedBox(height: 4),

          Text(
            isEdit
                ? "Update guest information"
                : "Add a new guest to your hotel",
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}