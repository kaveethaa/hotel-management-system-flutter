import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/data_providers.dart';
import '../widgets/reservation_card.dart';
import '../widgets/reservation_empty.dart';

class ReservationListSection extends ConsumerWidget {
  final String selectedStatus;
  final VoidCallback onRefresh;
  final Function(String reservationId) onEdit;

  const ReservationListSection({
    super.key,
    required this.selectedStatus,
    required this.onRefresh,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(reservationsProvider);
    final guests = ref.watch(guestsProvider);
    final rooms = ref.watch(roomsProvider);

    return reservations.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),

      error: (error, _) => Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),

      data: (reservationList) {
        final guestList = guests.value ?? [];
        final roomList = rooms.value ?? [];

        final filtered = reservationList.where((reservation) {
          if (selectedStatus == "All") {
            return true;
          }

          return reservation.status == selectedStatus;
        }).toList();

        if (filtered.isEmpty) {
          return const ReservationEmpty();
        }

        return RefreshIndicator(
          onRefresh: () async {
            onRefresh();
          },
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              24,
            ),

            itemCount: filtered.length,

            separatorBuilder: (_, __) =>
            const SizedBox(height: 16),

            itemBuilder: (context, index) {
              final reservation = filtered[index];

              final guest = guestList.firstWhere(
                    (e) => e.id == reservation.guestId,
                orElse: () => guestList.isNotEmpty
                    ? guestList.first
                    : throw Exception("Guest not found"),
              );

              final room = roomList.firstWhere(
                    (e) => e.id == reservation.roomId,
                orElse: () => roomList.isNotEmpty
                    ? roomList.first
                    : throw Exception("Room not found"),
              );

              return ReservationCard(
                reservation: reservation,
                guest: guest,
                room: room,

                onEdit: () {
                  onEdit(reservation.id);
                },

                onDeleted: () {
                  onRefresh();
                },
              );
            },
          ),
        );
      },
    );
  }
}