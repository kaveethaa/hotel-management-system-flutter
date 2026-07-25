import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/models.dart';
import 'reservation_popup_menu.dart';
import 'reservation_status_chip.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final Guest guest;
  final Room room;

  final VoidCallback onEdit;
  final VoidCallback onDeleted;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.guest,
    required this.room,
    required this.onEdit,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final checkIn = DateTime.parse(reservation.checkIn);
    final checkOut = DateTime.parse(reservation.checkOut);

    final dateFormat = DateFormat("dd MMM yyyy");
    final currency = NumberFormat.currency(symbol: "\$");

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Header
              Row(
                children: [

                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      guest.name.isEmpty
                          ? "G"
                          : guest.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          guest.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          guest.phone,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ReservationPopupMenu(
                    reservation: reservation,
                    onEdit: onEdit,
                    onDeleted: onDeleted,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Divider(color: Colors.grey.shade300),

              const SizedBox(height: 16),

              /// Room
              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.hotel_rounded,
                      color: Colors.indigo,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Room ${room.number}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          room.type,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ReservationStatusChip(
                    status: reservation.status,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Check In
              Row(
                children: [

                  const Icon(
                    Icons.login_rounded,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      dateFormat.format(checkIn),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Check Out
              Row(
                children: [

                  const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      dateFormat.format(checkOut),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: Row(
                  children: [

                    const Icon(
                      Icons.payments_rounded,
                      color: Colors.green,
                    ),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Text(
                        "Reservation Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      currency.format(
                        reservation.total,
                      ),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}