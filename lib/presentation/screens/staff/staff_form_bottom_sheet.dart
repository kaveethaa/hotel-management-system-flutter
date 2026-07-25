import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/models.dart';
import '../../providers/data_providers.dart';


class StaffFormBottomSheet extends StatelessWidget {

  final WidgetRef ref;
  final Staff? existing;

  const StaffFormBottomSheet({
    super.key,
    required this.ref,
    this.existing,
  });


  /// Open Add / Edit Staff Bottom Sheet
  static Future<void> show(
      BuildContext context,
      WidgetRef ref, {
        Staff? existing,
      }) {

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,

      backgroundColor: Colors.transparent,

      builder: (context) {

        return StaffFormBottomSheet(
          ref: ref,
          existing: existing,
        );

      },
    );

  }


  @override
  Widget build(BuildContext context) {

    return _StaffForm(
      ref: ref,
      existing: existing,
    );

  }

}
class _StaffForm extends ConsumerStatefulWidget {

  final WidgetRef ref;
  final Staff? existing;

  const _StaffForm({
    required this.ref,
    this.existing,
  });


  @override
  ConsumerState<_StaffForm> createState() => _StaffFormState();
}



class _StaffFormState extends ConsumerState<_StaffForm>
    with SingleTickerProviderStateMixin {


  final _formKey = GlobalKey<FormState>();


  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController salaryController;


  late String selectedRole;


  final List<String> roles = [

    "Manager",
    "Receptionist",
    "Housekeeping",
    "Chef",
    "Security",
    "Maintenance",

  ];

  IconData _roleIcon(String role) {
    switch (role) {
      case "Manager":
        return Icons.admin_panel_settings;

      case "Receptionist":
        return Icons.support_agent;

      case "Housekeeping":
        return Icons.cleaning_services;

      case "Chef":
        return Icons.restaurant;

      case "Security":
        return Icons.security;

      case "Maintenance":
        return Icons.handyman;


      default:
        return Icons.person;
    }
  }

  late AnimationController animationController;

  late Animation<double> fadeAnimation;

  late Animation<Offset> slideAnimation;

  Future<void> _saveStaff() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    final staff = Staff(

      id: widget.existing?.id ??
          DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),


      name:
      nameController.text.trim(),


      role:
      selectedRole,


      phone:
      phoneController.text.trim(),


      email:
      emailController.text.trim(),


      salary:
      double.tryParse(
        salaryController.text.trim(),
      ) ??
          0,

    );


    await saveStaff(

      staff,

      isNew:
      widget.existing == null,

    );


    widget.ref.invalidate(
      staffProvider,
    );


    if (mounted) {
      Navigator.pop(context);


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          behavior:
          SnackBarBehavior.floating,


          content: Text(

            widget.existing == null

                ? "Staff added successfully"

                : "Staff updated successfully",

          ),

        ),

      );
    }
  }

  @override
  void initState() {
    super.initState();


    /// Controllers

    nameController = TextEditingController(
      text: widget.existing?.name ?? "",
    );


    phoneController = TextEditingController(
      text: widget.existing?.phone ?? "",
    );


    emailController = TextEditingController(
      text: widget.existing?.email ?? "",
    );


    salaryController = TextEditingController(
      text: widget.existing == null
          ? ""
          : widget.existing!.salary.toStringAsFixed(0),
    );


    selectedRole =
        widget.existing?.role ?? roles.first;


    /// Header Animation

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );


    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );


    slideAnimation = Tween<Offset>(
      begin: const Offset(
        0,
        .2,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );


    animationController.forward();
  }


  @override
  void dispose() {
    nameController.dispose();

    phoneController.dispose();

    emailController.dispose();

    salaryController.dispose();


    animationController.dispose();


    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(

      initialChildSize: 0.88,

      minChildSize: 0.65,

      maxChildSize: 0.95,

      expand: false,


      builder: (context, scrollController) {
        return Container(

          decoration: const BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),

          ),


          child: SingleChildScrollView(

            controller: scrollController,


            padding: EdgeInsets.only(

              left: 20,

              right: 20,

              top: 16,

              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom + 30,

            ),


            child: Form(

              key: _formKey,


              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  /// Drag Handle

                  Center(

                    child: Container(

                      width: 60,

                      height: 6,


                      decoration: BoxDecoration(

                        color: Colors.grey.shade300,

                        borderRadius:
                        BorderRadius.circular(20),

                      ),

                    ),

                  ),


                  const SizedBox(height: 25),


                  /// Animated Header

                  FadeTransition(

                    opacity: fadeAnimation,


                    child: SlideTransition(

                      position: slideAnimation,


                      child: Column(

                        children: [


                          Center(

                            child: Container(

                              height: 90,

                              width: 90,


                              decoration: BoxDecoration(

                                shape: BoxShape.circle,


                                gradient:
                                const LinearGradient(

                                  colors: [

                                    Color(0xff667EEA),

                                    Color(0xff764BA2),

                                  ],

                                ),

                                boxShadow: [

                                  BoxShadow(

                                    color: Colors.black
                                        .withOpacity(.15),

                                    blurRadius: 15,

                                    offset:
                                    const Offset(0, 8),

                                  ),

                                ],

                              ),


                              child: const Icon(

                                Icons.person_add_alt_1,

                                size: 45,

                                color: Colors.white,

                              ),

                            ),

                          ),


                          const SizedBox(height: 15),


                          Text(

                            widget.existing == null

                                ? "Add New Staff"

                                : "Update Staff",


                            style: const TextStyle(

                              fontSize: 26,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),


                          const SizedBox(height: 8),


                          Text(

                            widget.existing == null

                                ? "Create employee profile"

                                : "Update employee details",


                            style: TextStyle(

                              color:
                              Colors.grey.shade600,

                              fontSize: 14,

                            ),

                          ),


                        ],

                      ),

                    ),

                  ),


                  const SizedBox(height: 30),

                  /// ===============================
                  /// Name Field
                  /// ===============================

                  TextFormField(

                    controller: nameController,


                    textCapitalization:
                    TextCapitalization.words,


                    decoration: InputDecoration(

                      labelText: "Full Name",

                      hintText: "Enter staff name",


                      prefixIcon: Container(

                        margin: const EdgeInsets.all(8),

                        decoration: BoxDecoration(

                          color: Colors.indigo.shade50,

                          borderRadius:
                          BorderRadius.circular(12),

                        ),

                        child: Icon(

                          Icons.person_outline,

                          color: Colors.indigo.shade600,

                        ),

                      ),


                      filled: true,

                      fillColor: Colors.grey.shade100,


                      border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide:
                        BorderSide.none,

                      ),


                      enabledBorder:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide:
                        BorderSide.none,

                      ),


                      focusedBorder:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide: BorderSide(

                          color: Colors.indigo.shade400,

                          width: 2,

                        ),

                      ),

                    ),


                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return "Please enter staff name";
                      }


                      if (value
                          .trim()
                          .length < 3) {
                        return "Name must contain 3 characters";
                      }


                      return null;
                    },

                  ),


                  const SizedBox(height: 18),


                  /// ===============================
                  /// Role Dropdown
                  /// ===============================

                  DropdownButtonFormField<String>(


                    value: selectedRole,


                    decoration: InputDecoration(

                      labelText: "Staff Role",

                      prefixIcon: Container(

                        margin:
                        const EdgeInsets.all(8),

                        decoration: BoxDecoration(

                          color: Colors.purple.shade50,

                          borderRadius:
                          BorderRadius.circular(12),

                        ),


                        child: Icon(

                          Icons.work_outline,

                          color: Colors.purple.shade600,

                        ),

                      ),


                      filled: true,

                      fillColor: Colors.grey.shade100,


                      border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide:
                        BorderSide.none,

                      ),


                      enabledBorder:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide:
                        BorderSide.none,

                      ),

                    ),


                    items: roles.map(

                          (role) {
                        return DropdownMenuItem(

                          value: role,


                          child: Row(

                            children: [


                              Icon(

                                _roleIcon(role),

                                size: 20,

                              ),


                              const SizedBox(width: 12),


                              Text(role),


                            ],

                          ),

                        );
                      },

                    ).toList(),


                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },

                  ),


                  const SizedBox(height: 18),


                  /// ===============================
                  /// Phone Field
                  /// ===============================

                  TextFormField(


                    controller: phoneController,


                    keyboardType:
                    TextInputType.phone,


                    decoration: InputDecoration(


                      labelText: "Phone Number",

                      hintText: "9876543210",


                      prefixIcon: Container(

                        margin:
                        const EdgeInsets.all(8),


                        decoration: BoxDecoration(

                          color: Colors.green.shade50,

                          borderRadius:
                          BorderRadius.circular(12),

                        ),


                        child: Icon(

                          Icons.phone_outlined,

                          color: Colors.green.shade700,

                        ),

                      ),


                      filled: true,


                      fillColor:
                      Colors.grey.shade100,


                      border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide:
                        BorderSide.none,

                      ),


                      enabledBorder:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide:
                        BorderSide.none,

                      ),


                      focusedBorder:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide: BorderSide(

                          color:
                          Colors.green.shade400,

                          width: 2,

                        ),

                      ),

                    ),


                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return "Please enter phone number";
                      }


                      if (value.length < 10) {
                        return "Enter valid phone number";
                      }


                      return null;
                    },


                  ),
                  const SizedBox(height: 18),


                  TextFormField(

                    controller: emailController,


                    keyboardType:
                    TextInputType.emailAddress,


                    decoration: InputDecoration(

                      labelText: "Email Address",

                      hintText: "staff@email.com",


                      prefixIcon: Container(

                        margin: const EdgeInsets.all(8),

                        decoration: BoxDecoration(

                          color: Colors.blue.shade50,

                          borderRadius:
                          BorderRadius.circular(12),

                        ),

                        child: Icon(

                          Icons.email_outlined,

                          color: Colors.blue.shade600,

                        ),

                      ),


                      filled: true,

                      fillColor: Colors.grey.shade100,


                      border: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide: BorderSide.none,

                      ),


                      enabledBorder: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide: BorderSide.none,

                      ),


                      focusedBorder: OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(18),

                        borderSide: BorderSide(

                          color: Colors.blue.shade400,

                          width: 2,

                        ),

                      ),

                    ),


                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return null;
                      }


                      if (!value.contains("@")) {
                        return "Enter valid email";
                      }


                      return null;
                    },

                  ),
                  const SizedBox(height: 20),


                  Container(

                    padding: const EdgeInsets.all(16),


                    decoration: BoxDecoration(

                      color: Colors.green.shade50,

                      borderRadius:
                      BorderRadius.circular(22),

                      border: Border.all(

                        color: Colors.green.shade200,

                      ),

                    ),


                    child: Row(

                      children: [


                        Container(

                          height: 45,

                          width: 45,


                          decoration: BoxDecoration(

                            color: Colors.green.shade100,

                            borderRadius:
                            BorderRadius.circular(14),

                          ),


                          child: Icon(

                            Icons.payments_outlined,

                            color: Colors.green.shade700,

                          ),

                        ),


                        const SizedBox(width: 14),


                        Expanded(

                          child: TextFormField(

                            controller: salaryController,


                            keyboardType:
                            TextInputType.number,


                            decoration: const InputDecoration(

                              labelText: "Monthly Salary",

                              hintText: "50000",

                              border: InputBorder.none,

                            ),


                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return "Enter salary";
                              }


                              return null;
                            },


                          ),

                        ),


                      ],

                    ),

                  ),
                  const SizedBox(height: 30),


                  SizedBox(

                    width: double.infinity,

                    height: 58,


                    child: DecoratedBox(

                      decoration: BoxDecoration(

                        gradient: const LinearGradient(

                          colors: [

                            Color(0xff667EEA),

                            Color(0xff764BA2),

                          ],

                        ),


                        borderRadius:
                        BorderRadius.circular(18),

                      ),


                      child: FilledButton.icon(

                        style:
                        FilledButton.styleFrom(

                          backgroundColor:
                          Colors.transparent,

                          shadowColor:
                          Colors.transparent,

                        ),


                        onPressed: _saveStaff,


                        icon: Icon(

                          widget.existing == null

                              ? Icons.person_add

                              : Icons.save,

                        ),


                        label: Text(

                          widget.existing == null

                              ? "Add Staff"

                              : "Update Staff",


                          style: const TextStyle(

                            fontSize: 16,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),

                      ),

                    ),

                  ),

                  /// Form fields start here

                  // Part 4 will continue here

                ],

              ),

            ),

          ),

        );
      },

    );
  }
}