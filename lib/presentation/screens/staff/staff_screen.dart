import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';

class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(staffProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showForm(context, ref, null),
          icon: const Icon(Icons.person_add), label: const Text('Add Staff')),
      body: staff.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            if (list.isEmpty) return const Center(child: Text('No staff yet'));
            return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final s = list[i];
                  return Card(child: ListTile(
                    leading: CircleAvatar(child: Text(s.name.substring(0, 1))),
                    title: Text(s.name),
                    subtitle: Text('${s.role} • ${s.phone}'),
                    trailing: Text(NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(s.salary)),
                    onTap: () => _showForm(context, ref, s),
                    onLongPress: () async {
                      final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                          title: const Text('Delete Staff?'), content: Text('Delete ${s.name}?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                          ]));
                      if (ok == true) { await deleteStaff(s.id); ref.invalidate(staffProvider); }
                    },
                  ));
                });
          }),
    );
  }

  void _showForm(BuildContext context, WidgetRef ref, Staff? existing) {
    final name = TextEditingController(text: existing?.name);
    final phone = TextEditingController(text: existing?.phone);
    final email = TextEditingController(text: existing?.email);
    final salary = TextEditingController(text: existing?.salary.toStringAsFixed(0));
    String role = existing?.role ?? 'Manager';

    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: StatefulBuilder(builder: (ctx, setSt) => Column(mainAxisSize: MainAxisSize.min, children: [
          Text(existing == null ? 'Add Staff' : 'Edit Staff',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: name, decoration: const InputDecoration(
              labelText: 'Name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: role,
              decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
              items: const ['Manager', 'Receptionist', 'Housekeeping', 'Chef', 'Security', 'Maintenance']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setSt(() => role = v!)),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: salary, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Salary', prefixText: '\$ ', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: () async {
            if (name.text.isEmpty || phone.text.isEmpty) return;
            final s = Staff(
                id: existing?.id ?? const Uuid().v4(),
                name: name.text.trim(), role: role, phone: phone.text.trim(),
                email: email.text.trim(), salary: double.tryParse(salary.text) ?? 0);
            await saveStaff(s, isNew: existing == null);
            ref.invalidate(staffProvider);
            if (ctx.mounted) Navigator.pop(ctx);
          }, child: Text(existing == null ? 'Add' : 'Update'))),
          const SizedBox(height: 20),
        ]))));
  }
}