import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecureTextfieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType inputType;
  final bool isRequired;
  final bool isObscured;
  final VoidCallback handler;
  final TextEditingController controller;
  const SecureTextfieldWidget(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.inputType,
      required this.isRequired,
      required this.controller,
      required this.isObscured,
      required this.handler});

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
            obscureText: isObscured,
            controller: controller,
            keyboardType: inputType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field tidak boleh kosong.';
              }
              if (value.length < 8) {
                return 'Password paling sedikit 8 karakter.';
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
              suffixIcon: IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: handler),
            ),
          ),
        ),
      ],
    );
  }
}
