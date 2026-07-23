import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/data_providers.dart';

class GuestsScreen extends ConsumerStatefulWidget {
  const GuestsScreen({super.key});
  @override
  ConsumerState<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends ConsumerState<GuestsScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final guests = ref.watch(guestsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Guests')),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/guests/form').then((_) => ref.invalidate(guestsProvider)),
          icon: const Icon(Icons.person_add), label: const Text('New Guest')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12),
            child: TextField(
                onChanged: (v) => setState(() => _q = v.toLowerCase()),
                decoration: const InputDecoration(hintText: 'Search by name or phone...',
                    prefixIcon: Icon(Icons.search), border: OutlineInputBorder(), isDense: true))),
        Expanded(child: guests.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (list) {
              final f = list.where((g) => _q.isEmpty
                  || g.name.toLowerCase().contains(_q)
                  || g.phone.toLowerCase().contains(_q)).toList();
              if (f.isEmpty) return const Center(child: Text('No guests found'));
              return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(guestsProvider),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: f.length,
                      itemBuilder: (_, i) {
                        final g = f[i];
                        return Card(child: ListTile(
                          leading: CircleAvatar(child: Text(g.name.substring(0, 1))),
                          title: Text(g.name),
                          subtitle: Text('${g.phone}\n${g.idType}: ${g.idNumber}'),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/guests/form?id=${g.id}').then((_) => ref.invalidate(guestsProvider)),
                          onLongPress: () async {
                            final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                                title: const Text('Delete Guest?'),
                                content: Text('Delete ${g.name}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                ]));
                            if (ok == true) { await deleteGuest(g.id); ref.invalidate(guestsProvider); }
                          },
                        ));
                      }));
            })),
      ]),
    );
  }
}