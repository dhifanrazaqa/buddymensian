import 'package:buddymensia/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownFieldWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool isRequired;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final IconData? icon;

  const DropdownFieldWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.items,
    required this.value,
    required this.onChanged,
    this.icon,
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
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            validator: (value) => value == null ? 'Field tidak boleh kosong.' : null,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            hint: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  hintText,
                  style: GoogleFonts.istokWeb(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                )),
            decoration: InputDecoration(
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
            ),
          ),
        ),
      ],
    );
  }
}
