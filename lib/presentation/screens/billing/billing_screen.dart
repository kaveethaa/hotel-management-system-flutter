import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/data_providers.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider);
    final reservations = ref.watch(reservationsProvider);
    final guests = ref.watch(guestsProvider);
    final rooms = ref.watch(roomsProvider);
    final colors = {'Paid': Colors.green, 'Pending': Colors.orange, 'Partial': Colors.blue};

    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('Generate'),
          onPressed: () async {
            final resList = reservations.value ?? [];
            final unbilled = resList.where((r) => r.status == 'Checked-Out').toList();
            if (unbilled.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No checked-out reservations to bill')));
              return;
            }
            final picked = await showModalBottomSheet<String>(
                context: context,
                builder: (_) => SafeArea(child: ListView(shrinkWrap: true, children: [
                  const Padding(padding: EdgeInsets.all(16),
                      child: Text('Select reservation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  ...unbilled.map((r) {
                    final g = (guests.value ?? []).firstWhere((x) => x.id == r.guestId);
                    final rm = (rooms.value ?? []).firstWhere((x) => x.id == r.roomId);
                    return ListTile(
                        title: Text('${g.name} • Room ${rm.number}'),
                        subtitle: Text(NumberFormat.currency(symbol: '\$').format(r.total)),
                        onTap: () => Navigator.pop(context, r.id));
                  }),
                ])));
            if (picked == null) return;
            final r = resList.firstWhere((x) => x.id == picked);
            final id = await generateBill(r, 0);
            ref.invalidate(billsProvider);
            if (context.mounted) context.push('/billing/invoice/$id');
          }),
      body: bills.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            if (list.isEmpty) return const Center(child: Text('No bills yet'));
            final resList = reservations.value ?? [];
            final gList = guests.value ?? [];
            return RefreshIndicator(
                onRefresh: () async => ref.invalidate(billsProvider),
                child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final b = list[i];
                      final r = resList.firstWhere((x) => x.id == b.reservationId,
                          orElse: () => resList.isNotEmpty ? resList.first : throw '');
                      final g = gList.firstWhere((x) => x.id == r.guestId,
                          orElse: () => gList.isNotEmpty ? gList.first : throw '');
                      return Card(child: ListTile(
                        leading: CircleAvatar(backgroundColor: colors[b.status],
                            child: const Icon(Icons.receipt, color: Colors.white)),
                        title: Text(g.name),
                        subtitle: Text('Bill #${b.id.substring(0, 8)}\n${NumberFormat.currency(symbol: '\$').format(b.total)}'),
                        isThreeLine: true,
                        trailing: Chip(label: Text(b.status, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            backgroundColor: colors[b.status], visualDensity: VisualDensity.compact),
                        onTap: () => context.push('/billing/invoice/${b.id}'),
                      ));
                    }));
          }),
    );
  }
}