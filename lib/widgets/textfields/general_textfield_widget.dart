import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralTextfieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType inputType;
  final bool isRequired;
  final TextEditingController controller;
  final int maxLines;
  const GeneralTextfieldWidget(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.inputType,
      required this.isRequired,
      required this.controller,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: GoogleFonts.istokWeb(fontSize: 14),
            ),
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 18,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field tidak boleh kosong.';
              }
              if (inputType == TextInputType.emailAddress &&
                  !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                return 'Masukkan email yang valid.';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.cyan, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
