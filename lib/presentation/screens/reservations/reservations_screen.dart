import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/data_providers.dart';

class ReservationsScreen extends ConsumerStatefulWidget {
  const ReservationsScreen({super.key});
  @override
  ConsumerState<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends ConsumerState<ReservationsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final res = ref.watch(reservationsProvider);
    final guests = ref.watch(guestsProvider);
    final rooms = ref.watch(roomsProvider);
    const statuses = ['All', 'Reserved', 'Checked-In', 'Checked-Out', 'Cancelled'];
    final colors = {
      'Reserved': Colors.blue, 'Checked-In': Colors.green,
      'Checked-Out': Colors.grey, 'Cancelled': Colors.red,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Reservations')),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/reservations/form').then((_) {
            ref.invalidate(reservationsProvider); ref.invalidate(roomsProvider);
          }),
          icon: const Icon(Icons.add), label: const Text('New')),
      body: Column(children: [
        SizedBox(height: 56, child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: statuses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => Center(child: ChoiceChip(
                label: Text(statuses[i]), selected: _filter == statuses[i],
                onSelected: (_) => setState(() => _filter = statuses[i]))))),
        Expanded(child: res.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (list) {
              final g = guests.value ?? []; final rms = rooms.value ?? [];
              final f = list.where((r) => _filter == 'All' || r.status == _filter).toList();
              if (f.isEmpty) return const Center(child: Text('No reservations'));
              return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(reservationsProvider),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: f.length,
                      itemBuilder: (_, i) {
                        final r = f[i];
                        final guest = g.firstWhere((x) => x.id == r.guestId,
                            orElse: () => g.isNotEmpty ? g.first : throw '');
                        final room = rms.firstWhere((x) => x.id == r.roomId,
                            orElse: () => rms.first);
                        final ci = DateTime.parse(r.checkIn);
                        final co = DateTime.parse(r.checkOut);
                        final df = DateFormat('MMM d');
                        return Card(child: ListTile(
                          leading: CircleAvatar(backgroundColor: colors[r.status],
                              child: const Icon(Icons.event, color: Colors.white)),
                          title: Text('${guest.name} • Room ${room.number}'),
                          subtitle: Text('${df.format(ci)} → ${df.format(co)}   ${NumberFormat.currency(symbol: '\$').format(r.total)}'),
                          trailing: Chip(label: Text(r.status, style: const TextStyle(fontSize: 10, color: Colors.white)),
                              backgroundColor: colors[r.status], visualDensity: VisualDensity.compact),
                          onTap: () => context.push('/reservations/form?id=${r.id}').then((_) {
                            ref.invalidate(reservationsProvider); ref.invalidate(roomsProvider);
                          }),
                        ));
                      }));
            })),
      ]),
    );
  }
}