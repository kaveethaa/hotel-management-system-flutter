import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/models.dart';
import '../../../providers/data_providers.dart';

class ReservationPopupMenu extends ConsumerWidget {
  final Reservation reservation;
  final VoidCallback onEdit;
  final VoidCallback onDeleted;

  const ReservationPopupMenu({
    super.key,
    required this.reservation,
    required this.onEdit,
    required this.onDeleted,
  });

  Future<void> _showDeleteDialog(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Reservation"),
        content: const Text(
          "Are you sure you want to delete this reservation?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Delete from database
      await deleteReservation(reservation.id);

      // Refresh provider
      ref.invalidate(reservationsProvider);

      // Notify parent
      onDeleted();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reservation deleted successfully"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (value) async {
        switch (value) {
          case 'edit':
            onEdit();
            break;

          case 'delete':
            await _showDeleteDialog(context, ref);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              SizedBox(width: 12),
              Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}