import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_management/presentation/screens/rooms/widgets/room_status_chip.dart';

import '../../providers/auth_provider.dart';
import '../../providers/data_providers.dart';
import 'sections/room_filter_chips.dart' hide RoomFilterChips;
import 'sections/room_search_bar.dart';
import 'sections/rooms_header.dart';
import 'sections/rooms_stats_section.dart';
import 'widgets/room_card.dart';

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
    final roomsAsync = ref.watch(roomsProvider);
    final isAdmin = ref.watch(authProvider).user?.role == 'Admin';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E88E5),
        onPressed: () => context
            .push('/rooms/form')
            .then((_) => ref.invalidate(roomsProvider)),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Room',
          style: TextStyle(color: Colors.white),
        ),
      )
          : null,

      body: SafeArea(
        child: Column(
          children: [
            const RoomsHeader(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  RoomSearchBar(
                    onChanged: (value) {
                      setState(() => _search = value.toLowerCase());
                    },
                  ),

                  const SizedBox(height: 16),

                  RoomFilterChips(
                    selected: _filter,
                    onChanged: (value) {
                      setState(() => _filter = value);
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: roomsAsync.when(
                loading: () =>
                const Center(child: CircularProgressIndicator()),

                error: (e, _) => Center(child: Text('Error: $e')),

                data: (rooms) {
                  final filtered = rooms.where((r) {
                    final matchesFilter =
                        _filter == 'All' || r.status == _filter;

                    final matchesSearch = _search.isEmpty ||
                        r.number.toLowerCase().contains(_search) ||
                        r.type.toLowerCase().contains(_search);

                    return matchesFilter && matchesSearch;
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(roomsProvider),

                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      children: [
                        RoomsStatsSection(rooms: rooms),

                        const SizedBox(height: 20),

                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 80),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.hotel_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No rooms found',
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
                                (room) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: RoomCard(
                                room: room,
                                isAdmin: isAdmin,
                                onTap: isAdmin
                                    ? () => context
                                    .push('/rooms/form?id=${room.id}')
                                    .then((_) => ref.invalidate(roomsProvider))
                                    : null,
                                onDelete: isAdmin
                                    ? () async {
                                  await deleteRoom(room.id);
                                  ref.invalidate(roomsProvider);
                                }
                                    : null,
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