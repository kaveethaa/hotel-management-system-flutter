import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/local/database_helper.dart';

Future<void> showRatingModal(BuildContext context, String guestId, String reservationId) async {
  int rating = 5;
  final controller = TextEditingController();
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(
            color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        const Text('How was your stay?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Your feedback helps us improve', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        StatefulBuilder(builder: (_, setSt) => RatingBar.builder(
            initialRating: 5, minRating: 1, allowHalfRating: false, itemCount: 5,
            itemSize: 44, glow: false,
            itemBuilder: (_, __) => const Icon(Icons.star, color: Color(0xFFD4AF37)),
            onRatingUpdate: (v) => setSt(() => rating = v.toInt()))),
        const SizedBox(height: 24),
        TextField(controller: controller, maxLines: 3,
            decoration: const InputDecoration(hintText: 'Share your experience (optional)',
                border: OutlineInputBorder())),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50,
            child: FilledButton(onPressed: () async {
              final db = await DatabaseHelper.instance.database;
              await db.insert('ratings', {
                'id': const Uuid().v4(), 'guest_id': guestId,
                'reservation_id': reservationId, 'rating': rating,
                'comment': controller.text.trim(),
                'created_at': DateTime.now().toIso8601String(),
              });
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback! ⭐')));
            }, child: const Text('Submit Review'))),
        const SizedBox(height: 20),
      ]),
    ),
  );
}