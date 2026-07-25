import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../data/datasources/local/database_helper.dart';
import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';

import 'sections/guest_form_header.dart';
import 'sections/guest_basic_info_section.dart';
import 'sections/guest_identity_section.dart';
import 'sections/guest_address_section.dart';
import 'sections/guest_submit_section.dart';

class GuestFormScreen extends ConsumerStatefulWidget {
  final String? guestId;

  const GuestFormScreen({
    super.key,
    this.guestId,
  });

  @override
  ConsumerState<GuestFormScreen> createState() => _GuestFormScreenState();
}

class _GuestFormScreenState extends ConsumerState<GuestFormScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final idNumberController = TextEditingController();
  final addressController = TextEditingController();

  String idType = 'Passport';

  bool loading = false;

  bool get isEdit => widget.guestId != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      loadGuest();
    }

    nameController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    idNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> loadGuest() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'guests',
      where: 'id=?',
      whereArgs: [widget.guestId],
      limit: 1,
    );

    if (result.isEmpty || !mounted) return;

    final guest = Guest.fromMap(result.first);

    setState(() {
      nameController.text = guest.name;
      phoneController.text = guest.phone;
      emailController.text = guest.email;
      idNumberController.text = guest.idNumber;
      addressController.text = guest.address;
      idType = guest.idType;
    });
  }

  Future<void> saveGuestData() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final guest = Guest(
      id: widget.guestId ?? const Uuid().v4(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      idType: idType,
      idNumber: idNumberController.text.trim(),
      address: addressController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    await saveGuest(
      guest,
      isNew: widget.guestId == null,
    );

    ref.invalidate(guestsProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [

              GuestFormHeader(
                isEdit: isEdit,
                guestName: nameController.text,
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      GuestBasicInfoSection(
                        nameController: nameController,
                        phoneController: phoneController,
                        emailController: emailController,
                      ),

                      const SizedBox(height: 10),

                      GuestIdentitySection(
                        idType: idType,
                        idNumberController: idNumberController,
                        onChanged: (value) {
                          setState(() {
                            idType = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      GuestAddressSection(
                        controller: addressController,
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              GuestSubmitSection(
                loading: loading,
                isEdit: isEdit,
                onPressed: saveGuestData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}