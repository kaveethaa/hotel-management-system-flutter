import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';
import 'staff_form_bottom_sheet.dart';
import 'widgets/staff_empty.dart';
import 'widgets/staff_header.dart';
import 'widgets/staff_list.dart';

class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffProvider);

    return staffAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text("Staff"),
        ),
        body: Center(
          child: Text(error.toString()),
        ),
      ),

      data: (staffList) {
        return Scaffold(
          appBar: StaffHeader(
            staff: staffList,
          ),

          floatingActionButton: FloatingActionButton.extended(
            heroTag: "add_staff",
            onPressed: () {
              StaffFormBottomSheet.show(
                context,
                ref,
              );
            },
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text("Add Staff"),
          ),

          body: staffList.isEmpty
              ? const StaffEmpty()
              : StaffList(
            staffList: staffList,

            onEdit: (Staff staff) {
              StaffFormBottomSheet.show(
                context,
                ref,
                existing: staff,
              );
            },

            onDelete: (Staff staff) async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Staff"),
                  content: Text(
                    "Are you sure you want to delete ${staff.name}?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );

              if (result == true) {
                await deleteStaff(staff.id);

                ref.invalidate(staffProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${staff.name} deleted successfully",
                      ),
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}