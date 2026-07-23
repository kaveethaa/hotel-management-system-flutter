import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_providers.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});
  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  String _filter = 'All';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomsProvider);
    final isAdmin = ref.watch(authProvider).user?.role == 'Admin';
    const statuses = ['All', 'Available', 'Occupied', 'Reserved', 'Cleaning', 'Maintenance'];
    final colors = {
      'Available': Colors.green, 'Occupied': Colors.orange,
      'Reserved': Colors.blue, 'Cleaning': Colors.purple, 'Maintenance': Colors.red,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Rooms')),
      floatingActionButton: isAdmin ? FloatingActionButton.extended(
          onPressed: () => context.push('/rooms/form').then((_) => ref.invalidate(roomsProvider)),
          icon: const Icon(Icons.add), label: const Text('Add Room')) : null,
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12),
            child: TextField(
                onChanged: (v) => setState(() => _search = v.toLowerCase()),
                decoration: const InputDecoration(hintText: 'Search room number...',
                    prefixIcon: Icon(Icons.search), border: OutlineInputBorder(),
                    isDense: true))),
        SizedBox(height: 56, child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: statuses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final s = statuses[i]; final sel = _filter == s;
              return Center(child: ChoiceChip(
                  label: Text(s), selected: sel,
                  onSelected: (_) => setState(() => _filter = s)));
            })),
        Expanded(child: rooms.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (list) {
              final filtered = list.where((r) =>
              (_filter == 'All' || r.status == _filter) &&
                  (_search.isEmpty || r.number.toLowerCase().contains(_search))).toList();
              if (filtered.isEmpty) return const Center(child: Text('No rooms found'));
              return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(roomsProvider),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final r = filtered[i];
                        return Card(child: ListTile(
                          leading: CircleAvatar(backgroundColor: colors[r.status] ?? Colors.grey,
                              child: Text(r.number.substring(0, 1), style: const TextStyle(color: Colors.white))),
                          title: Text('Room ${r.number} • ${r.type}'),
                          subtitle: Text('${NumberFormat.currency(symbol: '\$').format(r.price)}/night • Cap: ${r.capacity}'),
                          trailing: Chip(label: Text(r.status, style: const TextStyle(fontSize: 11, color: Colors.white)),
                              backgroundColor: colors[r.status] ?? Colors.grey, visualDensity: VisualDensity.compact),
                          onTap: isAdmin ? () => context.push('/rooms/form?id=${r.id}').then((_) => ref.invalidate(roomsProvider)) : null,
                          onLongPress: isAdmin ? () async {
                            final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                                title: const Text('Delete Room?'),
                                content: Text('Delete Room ${r.number}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                ]));
                            if (ok == true) { await deleteRoom(r.id); ref.invalidate(roomsProvider); }
                          } : null,
                        ));
                      }));
            })),
      ]),
    );
  }
}