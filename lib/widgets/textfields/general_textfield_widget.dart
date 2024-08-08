import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralTextfieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType inputType;
  final bool isRequired;
  final TextEditingController controller;
  final int maxLines;
  final IconData? icon;

  const GeneralTextfieldWidget({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.isRequired,
    required this.controller,
    this.maxLines = 1,
    this.icon,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          labelText,
          style: GoogleFonts.istokWeb(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            style: GoogleFonts.istokWeb(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.istokWeb(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Icon(icon, color: Colors.grey[400], size: 30),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.hijauTuaPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[400]!, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.cyan, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Field tidak boleh kosong.';
              }
              if (inputType == TextInputType.emailAddress &&
                  !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value ?? '')) {
                return 'Masukkan email yang valid.';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
