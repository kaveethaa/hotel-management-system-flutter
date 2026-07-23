import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../data/datasources/local/database_helper.dart';
import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';

class GuestFormScreen extends ConsumerStatefulWidget {
  final String? guestId;
  const GuestFormScreen({super.key, this.guestId});
  @override
  ConsumerState<GuestFormScreen> createState() => _GuestFormScreenState();
}

class _GuestFormScreenState extends ConsumerState<GuestFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _idNum = TextEditingController();
  final _addr = TextEditingController();
  String _idType = 'Passport';

  @override
  void initState() {
    super.initState();
    if (widget.guestId != null) _load();
  }

  Future<void> _load() async {
    final db = await DatabaseHelper.instance.database;
    final r = await db.query('guests', where: 'id=?', whereArgs: [widget.guestId], limit: 1);
    if (r.isEmpty || !mounted) return;
    final g = Guest.fromMap(r.first);
    setState(() {
      _name.text = g.name; _phone.text = g.phone; _email.text = g.email;
      _idNum.text = g.idNumber; _addr.text = g.address; _idType = g.idType;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final g = Guest(
        id: widget.guestId ?? const Uuid().v4(),
        name: _name.text.trim(), phone: _phone.text.trim(), email: _email.text.trim(),
        idType: _idType, idNumber: _idNum.text.trim(), address: _addr.text.trim(),
        createdAt: DateTime.now().toIso8601String());
    await saveGuest(g, isNew: widget.guestId == null);
    ref.invalidate(guestsProvider);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.guestId != null;
    return Scaffold(
      appBar: AppBar(title: Text(edit ? 'Edit Guest' : 'New Guest')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(key: _form, child: Column(children: [
          TextFormField(controller: _name, decoration: const InputDecoration(
              labelText: 'Full Name', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _phone, keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
              value: _idType,
              decoration: const InputDecoration(labelText: 'ID Type', border: OutlineInputBorder()),
              items: const ['Passport', 'Driving License', 'Aadhaar', 'National ID']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _idType = v!)),
          const SizedBox(height: 12),
          TextFormField(controller: _idNum, decoration: const InputDecoration(
              labelText: 'ID Number', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null),
          const SizedBox(height: 12),
          TextFormField(controller: _addr, maxLines: 2,
              decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder())),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 50,
              child: FilledButton(onPressed: _save, child: Text(edit ? 'Update' : 'Register Guest'))),
        ])),
      ),
    );
  }
}