import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/data_providers.dart';
import 'sections/guest_search_bar.dart';
import 'sections/guest_stats_section.dart';
import 'sections/guests_header.dart';
import 'widgets/guest_card.dart';

class GuestsScreen extends ConsumerStatefulWidget {
  const GuestsScreen({super.key});

  @override
  ConsumerState<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends ConsumerState<GuestsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final guestsAsync = ref.watch(guestsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E88E5),
        onPressed: () => context
            .push('/guests/form')
            .then((_) => ref.invalidate(guestsProvider)),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'New Guest',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const GuestsHeader(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: GuestSearchBar(
                onChanged: (value) {
                  setState(() => _query = value.toLowerCase());
                },
              ),
            ),

            Expanded(
              child: guestsAsync.when(
                loading: () =>
                const Center(child: CircularProgressIndicator()),

                error: (e, _) => Center(child: Text('Error: $e')),

                data: (guests) {
                  final filtered = guests.where((g) {
                    return _query.isEmpty ||
                        g.name.toLowerCase().contains(_query) ||
                        g.phone.toLowerCase().contains(_query) ||
                        g.idNumber.toLowerCase().contains(_query);
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(guestsProvider),

                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      children: [
                        GuestStatsSection(guests: guests),

                        const SizedBox(height: 20),

                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No guests found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...filtered.map(
                                (guest) => Padding(
                              padding:
                              const EdgeInsets.only(bottom: 16),
                              child: GuestCard(
                                guest: guest,
                                onEdit: () => context
                                    .push('/guests/form?id=${guest.id}')
                                    .then((_) => ref.invalidate(guestsProvider)),
                                onDelete: () async {
                                  await deleteGuest(guest.id);
                                  ref.invalidate(guestsProvider);
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}