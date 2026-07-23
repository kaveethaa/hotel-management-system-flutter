import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../data/datasources/local/database_helper.dart';
import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';

class RoomFormScreen extends ConsumerStatefulWidget {
  final String? roomId;
  const RoomFormScreen({super.key, this.roomId});
  @override
  ConsumerState<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends ConsumerState<RoomFormScreen> {
  final _form = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _price = TextEditingController();
  final _cap = TextEditingController(text: '2');
  final _desc = TextEditingController();
  String _type = 'Standard';
  String _status = 'Available';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.roomId != null) _load();
  }

  Future<void> _load() async {
    final db = await DatabaseHelper.instance.database;
    final r = await db.query('rooms', where: 'id=?', whereArgs: [widget.roomId], limit: 1);
    if (r.isEmpty || !mounted) return;
    final room = Room.fromMap(r.first);
    setState(() {
      _number.text = room.number; _price.text = '${room.price}';
      _cap.text = '${room.capacity}'; _desc.text = room.description;
      _type = room.type; _status = room.status;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final room = Room(
        id: widget.roomId ?? const Uuid().v4(),
        number: _number.text.trim(), type: _type, status: _status,
        price: double.parse(_price.text), capacity: int.parse(_cap.text),
        description: _desc.text.trim());
    await saveRoom(room, isNew: widget.roomId == null);
    ref.invalidate(roomsProvider);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.roomId != null;
    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Edit Room' : 'Add Room')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(key: _form, child: Column(children: [
          TextFormField(controller: _number, decoration: const InputDecoration(
              labelText: 'Room Number', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
              value: _type, decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Standard', child: Text('Standard')),
                DropdownMenuItem(value: 'Deluxe', child: Text('Deluxe')),
                DropdownMenuItem(value: 'Suite', child: Text('Suite')),
              ], onChanged: (v) => setState(() => _type = v!)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
              value: _status, decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
              items: const ['Available', 'Occupied', 'Reserved', 'Cleaning', 'Maintenance']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _status = v!)),
          const SizedBox(height: 12),
          TextFormField(controller: _price, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price/night', prefixText: '\$ ', border: OutlineInputBorder()),
              validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter valid price' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _cap, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capacity', border: OutlineInputBorder()),
              validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter valid capacity' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _desc, maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50,
              child: FilledButton(onPressed: _loading ? null : _save,
                  child: _loading ? const CircularProgressIndicator(color: Colors.white)
                      : Text(edit ? 'Update Room' : 'Add Room'))),
        ])),
      ),
    );
  }
}