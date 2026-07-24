import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/datasources/local/database_helper.dart';
import '../../../../data/models/models.dart';
import '../../providers/data_providers.dart';
import 'sections/basic_info_section.dart';
import 'sections/description_section.dart';
import 'sections/pricing_section.dart';
import 'sections/room_form_header.dart';

class RoomFormScreen extends ConsumerStatefulWidget {
  final String? roomId;

  const RoomFormScreen({super.key, this.roomId});

  @override
  ConsumerState<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends ConsumerState<RoomFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _number = TextEditingController();
  final _price = TextEditingController();
  final _capacity = TextEditingController(text: '2');
  final _description = TextEditingController();

  String _type = 'Standard';
  String _status = 'Available';

  bool _loading = false;

  bool get _isEdit => widget.roomId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadRoom();
  }

  Future<void> _loadRoom() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'rooms',
      where: 'id = ?',
      whereArgs: [widget.roomId],
      limit: 1,
    );

    if (result.isEmpty || !mounted) return;

    final room = Room.fromMap(result.first);

    setState(() {
      _number.text = room.number;
      _price.text = room.price.toString();
      _capacity.text = room.capacity.toString();
      _description.text = room.description;
      _type = room.type;
      _status = room.status;
    });
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final room = Room(
      id: widget.roomId ?? const Uuid().v4(),
      number: _number.text.trim(),
      type: _type,
      status: _status,
      price: double.parse(_price.text),
      capacity: int.parse(_capacity.text),
      description: _description.text.trim(),
    );

    await saveRoom(room, isNew: !_isEdit);

    ref.invalidate(roomsProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  void dispose() {
    _number.dispose();
    _price.dispose();
    _capacity.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SafeArea(
        child: Column(
          children: [
            RoomFormHeader(isEdit: _isEdit),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Live Preview Card
                      _RoomPreviewCard(
                        number: _number.text.isEmpty
                            ? '101'
                            : _number.text,
                        type: _type,
                        status: _status,
                      ),

                      const SizedBox(height: 24),

                      BasicInfoSection(
                        numberController: _number,
                        type: _type,
                        status: _status,
                        onTypeChanged: (v) =>
                            setState(() => _type = v),
                        onStatusChanged: (v) =>
                            setState(() => _status = v),
                      ),

                      const SizedBox(height: 20),

                      PricingSection(
                        priceController: _price,
                        capacityController: _capacity,
                      ),

                      const SizedBox(height: 20),

                      DescriptionSection(
                        controller: _description,
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF1E88E5),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                          ),
                          onPressed:
                          _loading ? null : _saveRoom,
                          icon: _loading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Icon(
                            _isEdit
                                ? Icons.save_rounded
                                : Icons.add_business_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            _isEdit
                                ? 'Update Room'
                                : 'Create Room',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomPreviewCard extends StatelessWidget {
  final String number;
  final String type;
  final String status;

  const _RoomPreviewCard({
    required this.number,
    required this.type,
    required this.status,
  });

  Color _statusColor() {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Occupied':
        return Colors.orange;
      case 'Reserved':
        return Colors.blue;
      case 'Cleaning':
        return Colors.purple;
      case 'Maintenance':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.king_bed_rounded,
            color: Colors.white,
            size: 34,
          ),
        ],
      ),
    );
  }
}