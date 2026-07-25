import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';
import 'staff_card.dart';

class StaffList extends StatelessWidget {
  final List<Staff> staffList;
  final Function(Staff)? onEdit;
  final Function(Staff)? onDelete;

  const StaffList({
    super.key,
    required this.staffList,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      itemCount: staffList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final staff = staffList[index];

        return StaffCard(
          staff: staff,
          onTap: () => onEdit?.call(staff),
          onDelete: () => onDelete?.call(staff),
        );
      },
    );
  }
}