import 'package:flutter/material.dart';

class GuestSubmitSection extends StatelessWidget {
  final bool loading;
  final bool isEdit;
  final VoidCallback onPressed;

  const GuestSubmitSection({
    super.key,
    required this.loading,
    required this.isEdit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: loading ? null : onPressed,
            icon: loading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : Icon(
              isEdit ? Icons.save_rounded : Icons.person_add_alt_1,
            ),
            label: Text(
              loading
                  ? "Please wait..."
                  : isEdit
                  ? "Update Guest"
                  : "Register Guest",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: FilledButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}