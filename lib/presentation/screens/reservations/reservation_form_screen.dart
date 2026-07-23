import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../data/datasources/local/database_helper.dart';
import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';

class ReservationFormScreen extends ConsumerStatefulWidget {
  final String? reservationId;
  const ReservationFormScreen({super.key, this.reservationId});
  @override
  ConsumerState<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends ConsumerState<ReservationFormScreen> {
  String? _guestId;
  String? _roomId;
  DateTime _ci = DateTime.now();
  DateTime _co = DateTime.now().add(const Duration(days: 1));
  String _status = 'Reserved';

  @override
  void initState() {
    super.initState();
    if (widget.reservationId != null) _load();
  }

  Future<void> _load() async {
    final db = await DatabaseHelper.instance.database;
    final r = await db.query('reservations', where: 'id=?', whereArgs: [widget.reservationId], limit: 1);
    if (r.isEmpty || !mounted) return;
    final res = Reservation.fromMap(r.first);
    setState(() {
      _guestId = res.guestId; _roomId = res.roomId;
      _ci = DateTime.parse(res.checkIn); _co = DateTime.parse(res.checkOut);
      _status = res.status;
    });
  }

  Future<void> _pickDate(bool isCheckIn) async {
    final d = await showDatePicker(
        context: context,
        initialDate: isCheckIn ? _ci : _co,
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (d == null) return;
    setState(() {
      if (isCheckIn) { _ci = d; if (!_co.isAfter(d)) _co = d.add(const Duration(days: 1)); }
      else { _co = d; }
    });
  }

  Future<void> _save() async {
    if (_guestId == null || _roomId == null) {
      _snack('Select guest and room'); return;
    }
    if (!_co.isAfter(_ci)) { _snack('Check-out must be after check-in'); return; }
    final avail = await isRoomAvailable(_roomId!, _ci, _co, excludeId: widget.reservationId);
    if (!avail) { _snack('Room is not available for selected dates'); return; }

    final rooms = ref.read(roomsProvider).value ?? [];
    final room = rooms.firstWhere((r) => r.id == _roomId);
    final nights = _co.difference(_ci).inDays.clamp(1, 999);

    final res = Reservation(
        id: widget.reservationId ?? const Uuid().v4(),
        guestId: _guestId!, roomId: _roomId!,
        checkIn: _ci.toIso8601String(), checkOut: _co.toIso8601String(),
        status: _status, total: room.price * nights,
        createdAt: DateTime.now().toIso8601String());
    await saveReservation(res, isNew: widget.reservationId == null);
    ref.invalidate(reservationsProvider); ref.invalidate(roomsProvider);
    if (mounted) context.pop();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final guests = ref.watch(guestsProvider).value ?? [];
    final rooms = ref.watch(roomsProvider).value ?? [];
    final availableRooms = rooms.where((r) =>
    r.status == 'Available' || r.status == 'Reserved' || r.id == _roomId).toList();
    final df = DateFormat('MMM d, y');
    final edit = widget.reservationId != null;

    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Edit Reservation' : 'New Reservation'), actions: [
        if (edit) IconButton(icon: const Icon(Icons.cancel),
            onPressed: () async {
              await cancelReservation(widget.reservationId!, _roomId!);
              ref.invalidate(reservationsProvider); ref.invalidate(roomsProvider);
              if (mounted) context.pop();
            }),
      ]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        DropdownButtonFormField<String>(
            value: _guestId,
            decoration: const InputDecoration(labelText: 'Guest', border: OutlineInputBorder()),
            items: guests.map((g) => DropdownMenuItem(value: g.id, child: Text(g.name))).toList(),
            onChanged: (v) => setState(() => _guestId = v)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
            value: _roomId,
            decoration: const InputDecoration(labelText: 'Room', border: OutlineInputBorder()),
            items: availableRooms.map((r) => DropdownMenuItem(value: r.id,
                child: Text('Room ${r.number} • ${r.type} • \$${r.price}'))).toList(),
            onChanged: (v) => setState(() => _roomId = v)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text('In: ${df.format(_ci)}'),
              onPressed: () => _pickDate(true))),
          const SizedBox(width: 8),
          Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text('Out: ${df.format(_co)}'),
              onPressed: () => _pickDate(false))),
        ]),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
            items: const ['Reserved', 'Checked-In', 'Checked-Out', 'Cancelled']
                .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _status = v!)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50,
            child: FilledButton(onPressed: _save, child: Text(edit ? 'Update' : 'Create Reservation'))),
      ])),
    );
  }
}